---
id: 0588-08AB-EAA1-45C1-9B92-584F-33F1-F22F
name: globals-and-ambient-context
title: Globals and Ambient Context
description: -
domain: vba
solution: knowlages-solution
category:
  - docs
group:
  - articles
tags:
  - vba
  - knowlages-solution
  - rubberduck
  - articles
author:
  - Rubberduck
url: https://rubberduckvba.blog/2021/03/19/globals-and-ambient-context/
created_at: 2025-11-19T08:43:04
---
# Globals and Ambient Context

Global scope is a tool, neither inherently necessary nor evil. State is typically encapsulated in objects with references passed as procedure arguments. Misuse of global scope, not the scope itself, causes problems.

### What is Global Scope?

VBA implements multiple scopes: local (procedure-level), module, project, and global. Local variables exist within procedures. Module variables are accessible within their declaring module. `Public` members of private modules and `Friend` members of public modules are project-accessible. `Public` members of public modules are globally accessible across projects.

**Keywords**: The `Global` keyword is deprecated; use `Public` instead. `Private` is recommended for module-level declarations, reserving `Dim` for local scope.

Scope determines identifier resolution. The VBA runtime searches scopes in order: local, module, project, then referenced libraries (VBA standard library, host application object model, additional references).

Accessibility shapes public and private interfaces through keywords like `Private`, `Public`, and `Friend`. All module members default to `Public` unless explicitly declared otherwise.

### Globals and Testability

Global variables provide convenient cross-scope data access. A global `Logger` object allows any scope to log without requiring explicit parameter passing. However, this creates testing complications: unit tests execute logging code irrelevant to their purpose. If logger code contains bugs, tests unrelated to logging fail inappropriately.

Code with global dependencies resists testing or becomes impossible to test. A global `Logger` would require a "kill switch" for test environments—modifying an otherwise clean interface solely for test awareness, which violates design principles.

#### Treating the Excel Object Model as a Dependency

User-defined functions (UDFs) that depend on `Application.Caller` and `Application.OnTime` present testing challenges. These global services from the Excel object model cannot be modified to accommodate testing.

Testing standard UDFs is trivial: supply inputs, execute function, assert correct outputs or expected errors. Testing side-effecting UDFs that manipulate global state is significantly more complex.

Unit tests must:
- Produce consistent outcomes regardless of external factors
- Execute quickly without I/O or network activity
- Run individually or in any order without affecting outcomes
- Support concurrent execution (theoretically; VBA does not support concurrency)

Shared state between tests requires careful setup and cleanup before and after each test to provide controlled environments.

### Testing Untestable Things

A UDF using `Application.OnTime` is untestable as written. Tests cannot wait for Excel to invoke scheduled macros or send actual HTTP requests. The function's dependencies are tightly coupled, preventing testability.

Making code testable requires introducing abstraction layers between dependencies. Code must work against abstractions rather than concrete implementations, enabling dependency injection for testing.

The solution involves wrapping required `Application` members in an abstraction, making code depend on the abstraction rather than invoking `Application` members directly.

#### Abstraction

Untestable code directly invokes global dependencies:

```vba
Public Function SideEffectingUDF(ByVal FirstParameter As String, ByVal SecondParameter As Long) As Variant
    Set SomeGlobalRange = Application.Caller.Offset(RowOffset:=1)
    With SomeGlobalDictionary.Clear.Add "FirstParameter", FirstParameter.Add "SecondParameter", SecondParameter
    End With
    ScheduleMacro
End Function
```

Tests must verify dependency invocation. Making the UDF conditionally execute different code paths for tests versus production violates testing principles:
- Increases cyclomatic complexity
- Tests execute different code than production
- Tests make implementation assumptions
- Violates the Liskov Substitution Principle

Refactored code uses ambient context:

```vba
Public Function SideEffectingUDF(ByVal FirstParameter As String, ByVal SecondParameter As Long) As Variant
    With AppContext.Current
        Set.Target =.Caller.Offset(RowOffset:=1).Property("FirstParameter") = FirstParameter.Property("SecondParameter") = SecondParameter.ScheduleMacro
    End With
End Function
```

The UDF depends solely on `AppContext.Current`, accessed via the default instance. Global state remains globally accessible but is now encapsulated in an object. Tests inject a `TestContext` instead of manipulating global state directly.

### Implementation

Dependencies are pulled from global scope and encapsulated in a class module. An instance of this class becomes an "ambient context" that remains globally accessible while introducing necessary abstraction for testability.

Leveraging the default instance of `AppContext` with `@PredeclaredId` annotation:

```vba
'@PredeclaredId
Option Explicit
Implements IAppContext
Private Type TState
    Factory As IAppContextFactory
    Current As IAppContext
End Type
Private This As TState

Public Property Get Current() As IAppContext
    If This.Current Is Nothing Then
        Set This.Current = This.Factory.Create
    End If
    Set Current = This.Current
End Property

Private Sub Class_Initialize()
    If Me Is AppContext Then
        Set This.Factory = New AppContextFactory
    End If
End Sub
```

The `Current` property caches created instances, making them globally accessible.

#### Abstract Factory

The default instance does not know the runtime type of `Current`. The `IAppContextFactory` dependency creates context instances. Tests inject a `TestContextFactory` that returns `TestContext` instances:

```vba
'@Folder "Tests.Stubs"
Option Explicit
Implements IAppContextFactory
Private Function IAppContextFactory_Create() As IAppContext
    Set IAppContextFactory_Create = New TestContext
End Function
```

Production code uses `AppContextFactory`:

```vba
'@Folder "AmbientContext"
Option Explicit
Implements IAppContextFactory
Private Function IAppContextFactory_Create() As IAppContext
    Set IAppContextFactory_Create = New AppContext
End Function
```

The abstract factory pattern spawns instances of unknown concrete types at runtime, enabling test injection of alternative implementations.

#### Context State

The context wraps `Application.Caller` and `Application.OnTime` functionality. The `IAppContext` interface:

```vba
'@Interface
Option Explicit
Public Property Get Caller() As Range
End Property
Public Property Get Target() As Range
End Property
Public Property Set Target(ByVal Value As Range)
End Property
Public Property Get Property(ByVal Name As String) As Variant
End Property
Public Property Let Property(ByVal Name As String, ByVal Value As Variant)
End Property
Public Property Get Properties() As Variant
End Property
Public Property Get Timer() As IAppTimer
End Property
Public Property Set Timer(ByVal Value As IAppTimer)
End Property
Public Sub Clear()
End Sub
```

The interface exposes indexed properties for key/value access rather than exposing the dictionary directly.

The `IAppTimer` dependency ensures single timer instance sharing across context instances using a provider mechanism:

```vba
Option Explicit
Implements ITimerProvider
Private Const MacroName As String = "Execute"
Private Property Get ITimerProvider_Timer() As IAppTimer
    Static Instance As AppTimer
    If Instance Is Nothing Then
        Set Instance = New AppTimer
        Instance.MacroName = MacroName
    End If
    Set ITimerProvider_Timer = Instance
End Property
```

### The Tests

Previously-untestable UDFs now accept testing:

```vba
Public Function TestUDF(ByVal SomeParameter As Double) As Boolean
    On Error GoTo CleanFail
    With AppContext.Current
        Set.Target =.Caller.Offset(RowOffset:=1).Property("Test1") = 42.Property("Test2") = 4.25 * SomeParameter.Timer.ExecuteMacroAsync
    End With
    TestUDF = True
CleanExit:
    Exit Function
CleanFail:
    TestUDF = False
    Resume CleanExit
End Function
```

When invoked from worksheets, `IAppContext.Caller` returns the actual `Range` reference. When invoked from tests, it returns a test cell reference. Similarly, `IAppTimer.ExecuteMacroAsync` schedules callbacks in production but merely records invocation in tests.

Test implementation:

```vba
'@TestMethod("Infrastructure")
Private Sub TestUDF_SchedulesMacro()
    Set AppContext.Factory = New TestContextFactory
    Dim Context As TestContext
    Set Context = AppContext.Current
    Dim StubTimer As TestTimer
    Set StubTimer = AppContext.Current.Timer
    Dim Result As Boolean
    Result = Functions.TestUDF(0)
    Const Expected As Long = 1
    Assert.AreEqual Expected, StubTimer.ExecuteMacroAsyncInvokes
End Sub
```

### Cohesion

Ambient Context addresses cross-cutting concerns and enables global scope usage without hindering testing. It stores state and dependencies that would otherwise require global scope when parameter passing is impossible.

State remains global. Globals that need not be global should not be global. Explicit interfaces like `IAppContext` enforce appropriate abstractions and resist context interface growth into over-engineered global modules.

Interfaces should not be designed to change. Cohesive modules feel complete, with members forming closely related groups. Poor cohesion suggests future member additions. Meaningful naming prevents treating context as a "state bag" for lazily stuffed state.

In .NET, ambient context appears in specialized scenarios like `System.Threading.Thread.CurrentThread`. Authorization mechanisms may also use it. In VBA, ambient context is rarely needed outside side-effecting UDF scenarios. Macros are typically simpler to refactor for testability.
