---
id: AD1F-EF16-E78A-413A-A4DC-9620-BB2E-7CE0
name: constructors-in-twinbasic
title: Constructors in twinBASIC
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
url: https://rubberduckvba.blog/2021/04/17/constructors-in-twinbasic/
created_at: 2025-11-19T08:43:03
---
# Constructors in twinBASIC

twinBASIC extends VSCode, compiling 100% VB6/VBA compatible code while redefining VB6 and VBA solution maintenance and extension. Language-level enhancements include actual constructors, previously only simulatable through factory methods in Visual Basic.

### Object Construction in VBA/VB6

Creating new class instances in VBA:

```vba
Dim thing As Something
Set thing = New Something
```

A specific sequence unfolds during `Set` assignment evaluation:
- The right-hand side evaluates first; a `<new-expression>` spawns a `New` instance of the `Something` class.
- As the object gets created and before the New operation returns, the `Class_Initialize` handler inside `Something` invokes.
- When `Class_Initialize` returns, the `New` operation completes and yields an object reference pointing to the new object.
- The object reference copies to the `thing` variable, legalizing member calls against it.

VBA/VB6 classes lack true constructors. `Class_Initialize` handlers appropriately initialize private instance state but function as callbacks invoked from actual "base class" constructors for COM objects, thus without parameters.

#### Default Instances & Factory Methods

VBA/VB6 classes have a hidden `VB_PredeclaredId` attribute defaulting to `False`, settable to `True` (manually or using Rubberduck's `@PredeclaredId` annotation). Document modules like `ThisWorkbook` and `Sheet1`, plus `UserForm` modules, have this attribute set to `True`.

With `VB_PredeclaredId = True`, the runtime automatically creates class instances named after the class itself. The global `UserForm1` identifier refers to the default instance of `UserForm1` class when used as an object, and to the `UserForm1` class type when used as a type.

Handling `Class_Initialize` in classes with `VB_PredeclaredId` set to `True` invokes the handler before the first reference to it. Handling `Class_Terminate` destroys default instances when no longer needed (nothing in-scope references them).

Default instances resemble global objects. Globals and OOP don't mesh well; magical implicit global objects spawned from language runtimes are problematic. However, treating default instances as types enables considering class default interface members as type-belonging members, defining explicit, separate interfaces that classes implement to expose intended instance functionality.

In many languages, type-belonging members (rather than instance-belonging) are "static". C# uses the `static` keyword; VBA/VB6's `Static` keyword has different meaning, lacking true "static" functionality. .NET type-level members use the `Shared` keyword, reserved but unimplemented in VB6. twinBASIC might implement this.

Treating VBA/VB6 class default instances as static classes (keeping default instances stateless, disallowing state/variable holding) maintains OOP principle adherence while leveraging language features simulating static behavior. This chiefly involves exposing factory methods effectively simulating parameterized constructors. Example `Something` class module with `SomeProperty` value property-injected:

```vba
'@PredeclaredId
Option Explicit
Implements ISomething
Private mValue As Long

Public Function Create(ByVal Value As Long) As ISomething
    Dim Result As Something
    Set Result = New Something
    Result.SomeProperty = Value
    Set Create = Result
End Function

Public Property Let SomeProperty(ByVal RHS As Long)
    mValue = RHS
End Property

Private Property Get ISomething_SomeProperty() As Long
    ISomething_SomeProperty = mValue
End Property
```

The `ISomething` interface exposes only `SomeProperty` with `Property Get` accessor (read-only). Issues arise:
- Exposing `Property Let`/`Set` mutators on the class's default interface supports property-injection in factory methods.
- Rubberduck flags write-only properties and suggests exposing `Property Get` accessors (reading written values should be possible).
- Properties visible on default interfaces resemble mutable state accessible from default instances. Without active prevention, default instances easily become stateful, creating dreadful global state living in classes.
- Clean interfaces without `Create` members (and without `Property Let` mutators) require implementing explicit non-default interfaces exposing intended calling code members.

### Actual Constructors

twinBASIC provides actual constructors parameterizable for non-COM-visible classes (like VBA or VB6). Constructors are special procedures named `New` (like the operator) whose sole purpose is initializing object state, enabling client code to receive fully-initialized objects: identical purpose as default instance factory methods.

Default instance factory methods become unnecessary in twinBASIC because actual constructors are definable. Implications include:

Constructor guidelines:
- Take constructor parameters for caller-initialized instance state.
- Initialize private instance fields from constructor parameters.
- Invoke any private initialization procedures required for valid object instances when constructors return.
- Validate all parameters and raise run-time errors given invalid parameter values.
- Avoid non-initialization work in constructors.
- Avoid invoking procedures performing non-initialization work from constructors.
- Avoid raising run-time errors in constructors (except from guard clauses validating parameter values).

Example: A `DbConnection` class might take a `ConnectionString` constructor parameter. The constructor stores the `ConnectionString` as instance-level state into a private field, then returns. Another method invoked by the object consumer invokes an `Open` method reading the `ConnectionString` and proceeding to open database connections. The `DbConnection` constructor could open connections itself (convenient for many use cases) but couples constructing `DbConnection` objects with connecting to databases. When reading:

```vba
Dim db As DbConnection = New DbConnection(connString)
```

Expectations are simply instantiating new `DbConnection` objects—nothing more. If merely creating object instances can raise run-time errors because network cables are unplugged, badly side-effecting constructors are present.

Inline initialization syntax (initial assignment on the same line as declaration) is legal in VB.NET and twinBASIC. VBA/VB6 must separate declarations (`Dim`) from instantiation and assignment instructions.

Creating `New` objects expects new object creation as boring things: no possibility of anything going wrong with spawning new class instances.

Constructors should adhere to the KISS principle: Keep It Stupid Simple. If anything more complicated than creating objects and setting properties happens in constructors, refactor so actual work triggers after object construction.

#### Implications

Constructors operate on instances in the process of being created, simplifying reasoning and implementation versus `Create` factory methods on class default interfaces. This provides access to internal state of constructing objects.

The implication: no need to expose `Property Let` mutators for property-injecting parameter values. Constructor injection directly assigns private fields without polluting class default interfaces with unnecessary members.

Since class default interfaces are no longer polluted with unnecessary members, extracting explicit interfaces to hide them becomes unnecessary. Since constructors invoke using the `New` operator, no need for predeclared default instances of classes for `Create` method accessibility to calling code.

twinBASIC constructors change everything, contrasted by comparing Classic VB with identical twinBASIC scenarios.

##### Simulating Constructors in Classic VB (VBA/VB6)

Example `Example` class simulating a parameterized constructor:

```vba
'@PredeclaredId
Option Explicit
Implements IExample

Private Type TState
    Value1 As Long
    Value2 As String
End Type

Private This As TState

Public Function Create(ByVal Value1 As Long, ByVal Value2 As String) As IExample
    Dim Result As Example
    Set Result = New Example
    Result.Value1 = Value1
    Result.Value2 = Value2
    Set Create = Result
End Function

Public Property Get Value1() As Long
    Value1 = This.Value1
End Property
Public Property Let Value1(ByVal RHS As Long)
    This.Value1 = RHS
End Property

Public Property Get Value2() As String
    Value2 = This.Value2
End Property
Public Property Let Value2(ByVal RHS As String)
    This.Value2 = RHS
End Property

Private Property Get IExample_Value1() As Long
    IExample_Value1 = This.Value1
End Property

Private Property Get IExample_Value2() As String
    IExample_Value2 = This.Value2
End Property
```

`IExample` is another class module exposing only `Public Property Get Value1() As Long` and `Public Property Get Value2() As String`. Calling code:

```vba
Dim x As IExample
Set x = Example.Create(42, "Test")
Debug.Print x.Value1, x.Value2
```

The `x` variable could legally cast to `Example`, making `x.Value = 10` legal. Coding against abstract interfaces provides `IExample.Value1` and `IExample.Value2` as get-only properties. This standard pattern performs dependency injection and initializes objects with properties before returning them to consuming code.

This works with relatively few caveats (casting to concrete/default interface allowed, or `Example.Value1 = 42` making default instances stateful unless actively guarded against). It's robust enough and makes rather clean APIs suitable for OOP and testable code.

Using the `Is` operator with `Me`, testing whether `Me Is Example` determines whether currently in the default instance of `Example` class. Adding `If Me Is Example Then Err.Raise 5` raises run-time errors as guard clauses in `Property Let` members, protecting against class/design misuse.

Rubberduck tooling makes writing most of this code essentially automatic, but ultimately it's considerable code—necessitated only because actual constructors cannot be parameterized.

##### Constructors in twinBASIC

The legacy-VB example should compile fine and work identically in twinBASIC, but the language offers new opportunities. twinBASIC executables don't necessarily share concerns with twinBASIC ActiveX DLLs. Standalone .exe projects enable anything desired, but libraries intended for legacy VB code use must consider intended COM-based clients.

COM clients (like VBA) don't support parameterized constructors. Public/exposed classes (with `VB_Exposed` attribute set to `True`) should define parameterless constructors. Either the legacy way with `Class_Initialize` handlers:

```vba
Private Sub Class_Initialize()
End Sub
```

Or the twinBASIC way with explicit parameterless constructors:

```vba
Public Sub New()
End Sub
```

Similar to VB.NET, twinBASIC constructors are `Sub` procedures named `New` in class modules. Ideally, constructors appear near module tops as first class members (not for technical reasons, but instinctive expectations).

Class parameterless constructors are default constructors because if no constructor is specified for classes, implicit ones necessarily exist. Classes defining parameterized constructors are understood as classes requiring constructor arguments; no implicit default/parameterless constructors exist then. COM clients could not create new instances of such classes.

In twinBASIC, the `Example` class would be written:

```vba
Class Example

    Private Type TState
        Value1 As Long
        Value2 As String
    End Type

    Private This As TState

    Public Sub New(ByVal Value1 As Long, ByVal Value2 As String)
        This.Value1 = Value1
        This.Value2 = Value2
    End Sub

    Public Property Get Value1() As Long
        Return This.Value1
    End Property

    Public Property Get Value2() As String
        Return This.Value2
    End Property

End Class
```

Calling code:

```vba
Dim x As Example = New Example(42, "Test")
Debug.Print x.Value1, x.Value2
```

This has identical compile-time restrictions as code written against read-only `IExample` VBA/VB6 interfaces. Parameterized construction enables constructor-injecting values and making `Example` class default interfaces read-only as intended.

twinBASIC still supports implementing interfaces, but here `IExample` get-only interfaces would be redundant. This brings most useful interfaces in twinBASIC closer to "pure" abstract interfaces implemented by multiple classes. Seeing `Thing` classes implement `IThing` interfaces would be suspicious, whereas in VBA/VB6 `IThing` would be interfaces for working with `Thing` instances when `Thing` is only used as types (`myThing = Thing.Create(42)`).

### Constructor Injection

VBA/VB6 with factory methods achieve property injection—using properties to "inject" dependencies into class instances. Factory methods invoke `Property Let`/`Set` procedures for this. Property injection example: setting `ADODB.Connection`'s `ConnectionString` after instantiating `Connection` objects:

```vba
Dim Conn As Connection
Set Conn = New Connection
Conn.ConnectionString = "..."
Conn.Open
```

This works but induces temporal coupling in client code. Callers must remember setting `ConnectionString` properties before invoking `Open` methods.

VBA/VB6 also supports method injection by taking dependencies as `Sub` or `Function` parameters. For `ConnectionString` examples, method injection would be `Open` methods taking connection strings as parameters:

```vba
Dim Conn As Connection
Set Conn = New Connection
Conn.Open "..."
```

This is better: calling code cannot "forget" supplying connection strings. The `Property Let ConnectionString` member becomes a wart requiring removal.

Method injection is great for connection strings when nothing needs them other than `Open` methods. If many class members need the same parameters, promoting dependencies to instance level can remove parameters from all these members. In VBA/VB6, this requires property injection. If classes have many members requiring `Connection` parameters, consider whether `Connection` should be class dependencies rather than method dependencies.

twinBASIC enables constructor injection, creating valid objects as soon as they exist:

```vba
Dim Conn As Connection = New Connection("...")
Conn.Open
```

If `Connection` classes take `ByVal ConnectionString As String` constructor arguments, constructors store strings in `Private` instance state. Exposing `ConnectionString` properties (get-only) is only necessary if reasons exist. Objects are immediately usable without temporal coupling.

Eventually, twinBASIC could support `ReadOnly` modifiers for instance fields, enforcing and guaranteeing immutability. Constructor roles then boil down to assigning all `ReadOnly` private instance fields.

Writing classes taking instance-level dependencies as constructor arguments throws class consumers into pits of success where doing things wrong is harder than doing them correctly. This is the single best reason to leverage constructors when possible.
