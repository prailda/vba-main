---
id: 80E5-467A-78CE-4369-80BD-CCDD-DD38-5382
name: undoing-and-redoing-stuff
title: Undoing and Redoing Stuff
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
url: https://rubberduckvba.blog/2025/05/31/undoing-and-redoing-stuff/
created_at: 2025-11-19T08:43:13
---
# Undoing and Redoing Stuff

## The Problem

Whenever VBA code touches a worksheet, Excel clears its undo stack. If undo functionality is desired for macro operations, nothing will magically restore the native stack. However, implementing step-by-step undo/redo functionality for everything a macro did in a workbook is possible.

Excel's undo drop-down reveals the approach: each individual action is represented by an object that describes the action and encapsulates information about the initial state of its target. If A1 contains 123, typing ABC and hitting undo restores 123; hitting redo changes it back to ABC. This demonstrates "last in, first out" stack behavior: items are piled on top and only the first item on top is ever taken.

Stack behavior can be implemented with a VBA.Collection by adding items normally but only reading/removing ("popping") the item at the last index.

The core question is abstracting anything that could be done to a worksheet. Complete coverage is unnecessary; more or less atomic commands can be implemented depending on needs. The key is creating something undoable.

## Abstractions

If requirements for an undoable command can be identified, they can be formalized in an IUndoable interface. A Description property and Undo and Redo methods are appropriate.

```vba
'@Interface
Option Explicit
'@Description("Undoes a previously performed action")
Public Sub Undo()
End Sub
'@Description("Redoes a previously undone action")
Public Sub Redo()
End Sub
'@Description("Describes the undoable action")
Public Property Get Description() As String
End Property
```

### Commands and Context

Using the command pattern, an ICommand interface looks like this:

```vba
'@Interface
Option Explicit
'@Description("Returns True if the command can be executed given the provided context")
Public Function CanExecute(ByVal Context As Object) As Boolean
End Function
'@Description("Executes an action given a context")
Public Sub Execute(ByVal Context As Object)
End Sub
```

This abstraction is similar to previous command patterns. An undoable command differs by how often it gets instantiated. If a command needn't remember whether it ran or what context it executed with, a single instance can be reused. Commands implementing IUndoable do know these things, meaning each instance can do the same thing in different contexts, requiring a new instance for each execution.

The Context parameter uses the generic object type because that's the most specific available at that abstraction level without limiting flexibility. Implementations must cast the parameter to more specific types as needed. This parameter encapsulates everything the command needs to operate. For a WriteRangeFormulaCommand, the context would provide a target Range and a formula String.

Similar to a ViewModel, the context class for a particular command is mostly specific to that command. Each context class can have little in common with other context classes. However, they can implement common validation behavior through an ICommandContext interface:

```vba
'@Interface
Option Explicit
'@Description("True if the model is valid in its current state")
Public Function IsValid() As Boolean
End Function
```

For WriteRangeFormulaContext, implementation could look like:

```vba
'@ModuleDescription("Encapsulates the model for a WriteToRangeFormulaCommand")
Option Explicit
Implements ICommandContext
Private Type TContext
    Target As Excel.Range
    Formula As String
End Type
Private This As TContext
'@Description("The target Range")
Public Property Get Target() As Excel.Range
    Set Target = This.Target
End Property
Public Property Set Target(ByVal RHS As Excel.Range)
    Set This.Target = RHS
End Property
'@Description("The formula or value to be written to the target")
Public Property Get Formula() As String
    Formula = This.Formula
End Property
Public Property Let Formula(ByVal RHS As String)
    This.Formula = RHS
End Property
Private Function ICommandContext_IsValid() As Boolean
    If Not This.Target Is Nothing Then
        If This.Target.Areas.Count = 1 Then
            ICommandContext_IsValid = True
        End If
    End If
End Function
```

Rubberduck's Encapsulate Field refactoring automatically expands This members into public properties, minimizing boilerplate code writing.

## Implementation

Add a WriteRangeFormulaCommand class implementing both ICommand and IUndoable. Interfaces should be clear and segregated, containing only members necessarily present in every implementation. Commands that can't be undone can omit implementing IUndoable.

The encapsulated state of an undoable command is straightforward: a reference to the context, something to hold initial state, and DidRun and DidUndo flags the command uses to know its state and what can be done:

- If not executed, DidRun is false
- If executed but not undone, DidUndo is false
- If undone, DidRun is necessarily true, and so is DidUndo
- If DidRun is true, command cannot execute again
- If DidUndo is true, cannot undo again
- If DidRun is false, cannot undo either
- Redo sets DidRun to false then re-executes the command

Full implementation:

```vba
'@ModuleDescription("An undoable command that writes to the Formula2 property of a provided Range target")
Option Explicit
Implements ICommand
Implements IUndoable
Private Type TState
    InitialFormulas As Variant
    Context As WriteToRangeFormulaContext
    DidRun As Boolean
    DidUndo As Boolean
End Type
Private This As TState
Private Function ICommand_CanExecute(ByVal Context As Object) As Boolean
    ICommand_CanExecute = CanExecuteInternal(Context)
End Function
Private Sub ICommand_Execute(ByVal Context As Object)
    ExecuteInternal Context
End Sub
Private Property Get IUndoable_Description() As String
    IUndoable_Description = GetDescriptionInternal
End Property
Private Sub IUndoable_Redo()
    RedoInternal
End Sub
Private Sub IUndoable_Undo()
    UndoInternal
End Sub
Private Function GetDescriptionInternal() As String
    Dim FormulaText As String
    If Len(This.Context.Formula) > 20 Then
        FormulaText = "formula"
    Else
        FormulaText = "'" & This.Context.Formula & "'"
    End If
    GetDescriptionInternal = "Write " & FormulaText & " to " & This.Context.Target.AddressLocal(RowAbsolute:=False, ColumnAbsolute:=False)
End Function
Private Function CanExecuteInternal(ByVal Context As Object) As Boolean
    On Error GoTo OnInvalidContext

    GuardInvalidContext Context
    CanExecuteInternal = Not This.DidRun

    Exit Function
OnInvalidContext:
    CanExecuteInternal = False
End Function
Private Sub ExecuteInternal(ByVal Context As WriteToRangeFormulaContext)

    GuardInvalidContext Context
    SetUndoState Context

    Debug.Print "> Executing action: " & GetDescriptionInternal

    Context.Target.Formula2 = Context.Formula
    This.DidRun = True

End Sub
Private Sub GuardInvalidContext(ByVal Context As Object)
    If Not TypeOf Context Is ICommandContext Then Err.Raise 5, TypeName(Me), "An invalid context type was provided."
    Dim SafeContext As ICommandContext
    Set SafeContext = Context
    If Not SafeContext.IsValid And Not TypeOf Context Is WriteToRangeFormulaContext Then Err.Raise 5, TypeName(Me), "An invalid context was provided."
End Sub
Private Sub SetUndoState(ByVal Context As WriteToRangeFormulaContext)
    Set This.Context = Context
    This.InitialFormulas = Context.Target.Formula2
End Sub
Private Sub UndoInternal()
    If Not This.DidRun Then Err.Raise 5, TypeName(Me), "Cannot undo what has not been done."
    If This.DidUndo Then Err.Raise 5, TypeName(Me), "Operation was already undone."

    Debug.Print "> Undoing action: " & GetDescriptionInternal

    This.Context.Target.Formula2 = This.InitialFormulas
    This.DidUndo = True
End Sub
Private Sub RedoInternal()
    If Not This.DidUndo Then Err.Raise 5, TypeName(Me), "Cannot redo what was never undone."
    ExecuteInternal This.Context
    This.DidUndo = False
End Sub
```

Much of this code would be identical in any other undoable command. Only ExecuteInternal and UndoInternal methods need to differ in the part that actually performs or reverts the undoable action. GetDescriptionInternal string would describe different commands differently: "Write (formula) to (target address)" for this command, but "Set number format for (target address)" or "Format (edge) border of (target address)" for others. These descriptions can be used in UI components to depict undo/redo stack contents.

## Management

An object responsible for managing undo and redo stacks needs to expose simple methods to Push and Pop items, a way to Clear everything, and perhaps a method to get an array with all command descriptions for display. Popping logic should push the retrieved item into the redo stack, and redoing an action should push it back into the undo stack.

### Undo/Redo Mechanics

Enter UndoManager, invoked from a predeclared instance to ensure a single undo/redo stack exists. Any non-default instance usage raises an error:

```vba
'@PredeclaredId
Option Explicit
Private UndoStack As Collection
Private RedoStack As Collection
Public Sub Clear()
    Do While UndoStack.Count > 0
        UndoStack.Remove 1
    Loop
    Do While RedoStack.Count > 0
        RedoStack.Remove 1
    Loop
End Sub
Public Sub Push(ByVal Action As IUndoable)
    ThrowOnInvalidInstance
    UndoStack.Add Action
End Sub
Public Function PopUndoStack() As IUndoable
    ThrowOnInvalidInstance

    Dim Item As IUndoable
    Set Item = UndoStack.Item(UndoStack.Count)

    UndoStack.Remove UndoStack.Count
    RedoStack.Add Item

    Set PopUndoStack = Item
End Function
Public Function PopRedoStack() As IUndoable
    ThrowOnInvalidInstance

    Dim Item As IUndoable
    Set Item = RedoStack.Item(RedoStack.Count)

    RedoStack.Remove RedoStack.Count
    UndoStack.Add Item

    Set PopRedoStack = Item
End Function
Public Property Get CanUndo() As Boolean
    CanUndo = UndoStack.Count > 0
End Property
Public Property Get CanRedo() As Boolean
    CanRedo = RedoStack.Count > 0
End Property
Public Property Get UndoState() As Variant
    If Not CanUndo Then Exit Sub
    ReDim Items(1 To UndoStack.Count) As String
    Dim StackIndex As Long
    For StackIndex = 1 To UndoStack.Count
        Dim Item As IUndoable
        Set Item = UndoStack.Item(StackIndex)
        Items(StackIndex) = StackIndex & vbTab & Item.Description
    Next
    UndoState = Items
End Property
Public Property Get RedoState() As Variant
    If Not CanRedo Then Exit Property
    ReDim Items(1 To RedoStack.Count) As String
    Dim StackIndex As Long
    For StackIndex = 1 To RedoStack.Count
        Dim Item As IUndoable
        Set Item = RedoStack.Item(StackIndex)
        Items(StackIndex) = StackIndex & vbTab & Item.Description
    Next
    RedoState = Items
End Property
Private Sub ThrowOnInvalidInstance()
    If Not Me Is UndoManager Then Err.Raise 5, TypeName(Me), "Instance is invalid"
End Sub
Private Sub Class_Initialize()
    Set UndoStack = New Collection
    Set RedoStack = New Collection
End Sub
Private Sub Class_Terminate()
    Set UndoStack = Nothing
    Set RedoStack = Nothing
End Sub
```

### A Friendly API

At this point the API could be consumed, but things would get repetitive. Make a CommandManager predeclared object to simplify how VBA code works with undoable commands. Accept tight coupling with the UndoManager class, which is simply wrapped here:

```vba
'@PredeclaredId
Option Explicit
Public Sub WriteToFormula(ByVal Target As Range, ByVal Formula As String)
    Dim Command As ICommand
    Set Command = New WriteToRangeFormulaCommand

    Dim Context As WriteToRangeFormulaContext
    Set Context = New WriteToRangeFormulaContext

    Set Context.Target = Target
    Context.Formula = Formula

    RunCommand Command, Context
End Sub
Public Sub SetNumberFormat(ByVal Target As Range, ByVal FormatString As String)
    Dim Command As ICommand
    Set Command = New SetNumberFormatCommand

    Dim Context As SetNumberFormatContext
    Set Context = New SetNumberFormatContext

    Set Context.Target = Target
    Context.FormatString = FormatString

    RunCommand Command, Context
End Sub
'TODO expose new commands here
Public Sub UndoAction()
    If UndoManager.CanUndo Then UndoManager.PopUndoStack.Undo
End Sub
Public Sub UndoAll()
    Do While UndoManager.CanUndo
        UndoManager.PopUndoStack.Undo
    Loop
End Sub
Public Sub RedoAction()
    If UndoManager.CanRedo Then UndoManager.PopRedoStack.Redo
End Sub
Public Sub RedoAll()
    Do While UndoManager.CanRedo
        UndoManager.PopRedoStack.Redo
    Loop
End Sub
Public Property Get CanUndo() As Boolean
    CanUndo = UndoManager.CanUndo
End Property
Public Property Get CanRedo() As Boolean
    CanRedo = UndoManager.CanRedo
End Property
Private Sub RunCommand(ByVal Command As ICommand, ByVal Context As ICommandContext)
    If Command.CanExecute(Context) Then
        Command.Execute Context
        StackUndoable Command
    Else
        Debug.Print "Command cannot be executed in this context."
    End If
End Sub
Private Sub ThrowOnInvalidInstance()
    If Not Me Is CommandManager Then Err.Raise 5, TypeName(Me), "Instance is invalid"
End Sub
Private Sub StackUndoable(ByVal Command As Object)
    If TypeOf Command Is IUndoable Then
        Dim Undoable As IUndoable
        Set Undoable = Command
        UndoManager.Push Undoable
    End If
End Sub
```

Now that commands can be transparently created, run, and stacked, all complexity is hidden behind simple methods. Calling code doesn't need to know about commands and context classes, or even the UndoManager.

## Beyond

This could be extended with FormatRangeFontCommand working with a context encapsulating formatting information (FontName, FontSize, FontBold, etc.) as a single undoable operation. As long as the command tracks initial state of everything touched, it can all be undone.

FormatRangeBorderCommand was attempted but removed because unformatting borders in Excel is harder than formatting them. Setting bottom border line style and width to original values doesn't remove the border as xlLineStyleNone appears to have no effect. Offsetting or extending the target to compensate would complicate the example with edge-case handling.

This doesn't invalidate the idea but serves as a reminder that this isn't a native undo operation. More actions are simply performed, with these new actions bringing the sheet back to its prior state.

An entirely undoable macro could look like:

```vba
Public Sub DoSomething()
    With CommandManager
        .WriteToFormula Sheet1.Range("A1"), "Hello"
        .WriteToFormula Sheet1.Range("B1"), "World!"
        .WriteToFormula Sheet1.Range("C1:C10"), "=RANDBETWEEN(0, 255)"
        .WriteToFormula Sheet1.Range("D1:D10"), "=SUM($C$1:$C1)"
        .SetNumberFormat Sheet1.Range("D1:D10"), "$#,##0.00"
    End With
End Sub
```
