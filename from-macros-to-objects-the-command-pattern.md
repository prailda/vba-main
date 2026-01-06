---
id: 548D-0980-B3D4-4427-810E-E3EA-32BE-5CF3
name: from-macros-to-objects-the-command-pattern
title: "From Macros to Objects: The Command Pattern"
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
url: https://rubberduckvba.blog/2020/11/19/from-macros-to-objects-the-command-pattern/
created_at: 2025-11-19T08:43:04
---
# From Macros to Objects: The Command Pattern

Procedural macros implement `Public Sub DoSomething` procedures executing library-defined object member invocations in top-to-bottom sequences. Clean procedural code organizes this as a small, high-abstraction public procedure with increasingly lower-abstraction private procedures underneath.

A `MakeSalesReport` macro module structure demonstrates separation of concerns: breaking problems into smaller sub-steps achieves logical organization. Procedures are the verbs expressing code actions. Smaller procedures enable precise, accurate naming describing their exact function.

Code chunks describable with comments like "this chunk reticulates splines" indicate extraction opportunities. Extracting into named procedure scopes (`ReticulateSplines`) replaces comments and code blocks with single, self-explanatory procedure calls.

```vba
Option Explicit

Public Sub DoSomething()
    DoStuff
    Dim FileName As String
    FileName = GetFileName()
    DoMoreStuff FileName
End Sub

Private Sub DoStuff()
End Sub

Private Function GetFileName() As String
End Function

Private Sub DoMoreStuff(ByVal FileName As String)
End Sub
```

Object-oriented programming increases abstraction levels. `Public Sub DoSomething` macro procedures reside in standard modules painting broad-brush pictures, with implementation details in private procedures of separate class modules.

Classes provide nouns; procedures provide verbs. Objects are things; procedures do things. A `SomeMacro` class encapsulates "do something" functionality. Each macro implementation resides in dedicated class modules, leaving standard modules high-abstraction and clear.

Macro execution involves: 1) creating dependencies, 2) creating and initializing the macro object, 3) invoking a `Run` method:

```vba
Option Explicit
Private Const ConnectionString As String = "..."

Public Sub DoSomething()
    Dim DbService As IDbService
    Set DbService = SomeDbService.Create(ConnectionString)
    With SomeMacro.Create(Sheet1, DbService).Run
    End With
End Sub
```

This demonstrates dependency injection and inversion of control. The `.Run` member call executes the macro. Without an interface formalizing the concept, different macros could use inconsistent execution methods (`Run`, `Execute`, `DoSomething`). An interface enforces structure.

Interfaces and `Implements` tell the compiler "this class is a macro with a method that runs it":

```vba
'@ModuleDescription "Represents an executable macro."
'@Interface
Option Explicit

'@Description "Runs the macro."
Public Sub Run()
End Sub
```

Implementations use `Implements IMacro` with a `Private Sub IMacro_Run` procedure invoking a `Run` procedure that delegates to specialized objects (dependencies).

A macro in a class module implementing `IMacro` constitutes a command pattern:
- Caller: the `Public Sub DoSomething` macro procedure
- Command: the `IMacro` interface
- Concrete command: the `SomeMacro` class
- Dependencies: receivers

The `IMacro` interface abstracts "running a macro," representing "something that can run"—the command pattern essence.

### Divide & Conquer

User interfaces for add/delete/update operations benefit from "divide & conquer" organization:

```vba
Option Explicit

Public Property Get Model() As SomeModel
End Property

Private Sub CreateNewItem()
    With New ItemEditorForm.Show
        If.Cancelled Then Exit Sub
        AddToSource.Model
    End With
End Sub

Private Sub AddToSource(ByVal Thing As Something)
    Model.AddThing Thing
End Sub

Private Sub RemoveFromSource(ByVal Thing As Something)
    Model.RemoveThing Thing
End Sub

Private Sub DeleteSelectedItems()
    Dim i As Long
    For i = Me.ItemsBox.ListCount - 1 To 0 Step -1
        If Me.ItemsBox.Selected(i) Then
            Dim Item As Something
            Set Item = ListSource(Me.ItemsBox.ListIndex)
            If Not Item Is Nothing Then
                RemoveFromSource Item
            End If
        End If
    Next
End Sub

Private Sub EditSelectedItem()
    Dim Item As Something
    Set Item = ListSource(Me.ItemsBox.ListIndex)
    If Item Is Nothing Then Exit Sub
    With New ItemEditorForm
        Set.Model = Item.Show
        If.Cancelled Then Exit Sub
        UpdateSourceItem.Model
    End With
End Sub

Private Sub CreateButton_Click()
    CreateNewItem
End Sub

Private Sub DeleteButton_Click()
    DeleteSelectedItems
End Sub

Private Sub EditButton_Click()
    EditSelectedItem
End Sub
```

Factoring button actions into dedicated procedures enables meaningful naming and clear functionality separation. Click handlers fork execution elsewhere, becoming simple one-liners painting broad pictures.

Extracting private methods facilitates later restructuring: entire scopes move easily versus tedious event handler refactoring.

Enabling/disabling buttons based on selection state requires additional boilerplate:

```vba
Private Sub SetButtonsEnabledState()
    Me.EditButton.Enabled = (Model.SelectedItems.Count = 1)
    Me.DeleteButton.Enabled = (Model.SelectedItems.Count > 0)
End Sub

Private Sub ItemsBox_Change()
    SetModelSelectedItems
    SetButtonsEnabledState
End Sub
```

Multiple controls with enabled rules and change handlers create noise, reducing signal. This indicates abstraction level should increase.

Moving boilerplate to standard module `Public` procedures defeats object encapsulation. When procedures need state, state becomes global—an undesirable outcome.

### Command & Conquer

Using the command pattern, `CreateButton_Click` handlers kick logic into action, but logic resides in `ICommand` implementations encapsulating dependencies and state outside form code-behind without global scope.

The `ICommand` interface:

```vba
'@Interface
Option Explicit

Public Function CanExecute(ByVal Context As Object) As Boolean
End Function

Public Sub Execute(ByVal Context As Object)
End Sub

Public Property Get Description() As String
End Property
```

Commands provide:
- User-friendly descriptions
- Functions determining current executability given context
- Execute procedures running the command with context

The `Context` parameter encapsulates state/data. In MVVM, this is the ViewModel instance.

MVVM command bindings use `Description` for control tooltips and automatically invoke `CanExecute` as properties update, enabling/disabling bound buttons. The command pattern works excellently with Model-View-ViewModel but does not require it.

Stripped interface without `Description`:

```vba
'@Interface
Option Explicit

Public Function CanExecute(ByVal Context As Object) As Boolean
End Function

Public Sub Execute(ByVal Context As Object)
End Sub
```

The form code-behind melts:

```vba
Private CreateNewItem As ICommand
Private DeletedSelectedItems As ICommand
Private EditSelectedItem As ICommand

Public Property Get Model() As Object
End Property

Private Sub CreateButton_Click()
    CreateNewItem.Execute Me.Model
End Sub

Private Sub DeleteButton_Click()
    DeleteSelectedItems.Execute Me.Model
End Sub

Private Sub EditButton_Click()
    EditSelectedItem.Execute Me.Model
End Sub
```

Lower-abstraction implementation details move into distinct `ICommand` implementation objects. Forms remain unaware of command execution methods.

A `CreateNewItemCommand` implementation:

```vba
Option Explicit
Implements ICommand

Private Function ICommand_CanExecute(ByVal Context As Object) As Boolean
    ICommand_CanExecute = True
End Function

Private Sub ICommand_Execute(ByVal Context As Object)
    With New ItemEditorForm.Show
        If.Cancelled Then Exit Sub
        AddToSource.Model, Context
    End With
End Sub

Private Sub AddToSource(ByVal Thing As Something, ByVal Context As Object)
    Context.AddThing Thing
End Sub
```

Command implementations validate context types with assertions and casts:

```vba
Private Sub DoSomething(ByVal Context As Object)
    Debug.Assert TypeOf Context Is Class1
    Dim LocalContext As Class1
    Set LocalContext = Context
End Sub
```

Moving implementation from `Click` handlers enables button repurposing and command reuse. Forms need not know concrete `ICommand` implementations; swapping commands requires only changing implementation references.

### One Step Further

Commands are objects passable as parameters. Model-View-ViewModel leverages this.

MVVM object model provides an `AppContext` exposing `ICommandManager` holding all command binding references. `IBindingManager` notifies when property bindings update, triggering `CanExecute` evaluation.

MVVM eliminates manual event handler wiring. Form code-behind contains only binding wiring for controls to property and command bindings, plus `IView` and `ICancellable` interface implementations:

```vba
Option Explicit
Implements IView
Implements ICancellable

Private Type TState
    Context As MVVM.IAppContext
    ViewModel As ExampleViewModel
    IsCancelled As Boolean
    CreateNewItem As ICommand
    DeletedSelectedItems As ICommand
    EditSelectedItem As ICommand
End Type

Private This As TState

Public Property Get ViewModel() As ExampleViewModel
    Set ViewModel = This.ViewModel
End Property

Private Sub InitializeView()
    With This.Context.Commands.BindCommand ViewModel, Me.CreateButton, ViewModel.CreateNewItem.BindCommand ViewModel, Me.DeleteButton, ViewModel.DeleteSelectedItems.BindCommand ViewModel, Me.EditButton, ViewModel.EditSelectedItem.BindCommand ViewModel, Me.CancelButton, CancelCommand.Create(Me)
    End With
End Sub
```

Forms need not know specific `ICommand` implementations. Commands bind to public `ICommand` properties on ViewModel objects or inline-created instances like `CancelCommand`.

### Full Circle: EventCommand (MVVM)

Complex commands warrant dedicated classes. Trivial commands can be overkill when ViewModels already access necessary objects.

`EventCommand` allows ViewModels to supply implementations:

```vba
'@PredeclaredId
'@Exposed
Option Explicit
Implements ICommand

Private Type TState
    Description As String
End Type

Private This As TState

Public Event OnCanExecute(ByVal Context As Object, ByRef outResult As Boolean)
Public Event OnExecute(ByVal Context As Object)

Public Function Create(ByVal Description As String) As ICommand
    Dim Result As EventCommand
    Set Result = New EventCommand
    Result.Description = Description
    Set Create = Result
End Function

Public Property Get Description() As String
    Description = This.Description
End Property

Friend Property Let Description(ByVal RHS As String)
    This.Description = RHS
End Property

Private Function ICommand_CanExecute(ByVal Context As Object) As Boolean
    Dim outResult As Boolean
    outResult = True
    RaiseEvent OnCanExecute(Context, outResult)
    ICommand_CanExecute = outResult
End Function

Private Property Get ICommand_Description() As String
    ICommand_Description = This.Description
End Property

Private Sub ICommand_Execute(ByVal Context As Object)
    RaiseEvent OnExecute(Context)
End Sub
```

ViewModel usage:

```vba
Private WithEvents PseudoDelegateCommand As EventCommand

Private Sub Class_Initialize()
    Set PseudoDelegateCommand = EventCommand.Create("Full circle!")
End Sub

Private Sub PseudoDelegateCommand_OnCanExecute(ByVal Context As Object, outResult As Boolean)
End Sub

Private Sub PseudoDelegateCommand_OnExecute(ByVal Context As Object)
End Sub
```

This moves `Click` handlers from View into ViewModel as callbacks invoked by MVVM infrastructure responding to control events and `INotifyPropertyChanged` notifications.

From a testability standpoint, `EventCommand` handlers should not require dependencies the ViewModel lacks. Tests property-inject stub dependencies. Unless the ViewModel already depends on abstractions for database or file system access, handlers should not access these resources.

### You're in command

The command pattern applies to simple macro workbooks and full MVP/MVC/MVVM applications. It moves functionality from code-behind to appropriate locations. Unless writing Smart UI, that location is rarely View code-behind.

Implementing `ICommand` directly moves code from UI to dedicated command classes.

Using `EventCommand` with MVVM moves code anywhere in class modules (only classes support `WithEvents` instances). ViewModels commonly include high-abstraction code providing command implementations.
