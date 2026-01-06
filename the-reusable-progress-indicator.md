---
id: 1B4D-7A4A-464E-4C63-AB97-6A0C-5A1C-9622
name: the-reusable-progress-indicator
title: The Reusable Progress Indicator
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
url: https://rubberduckvba.blog/2018/01/12/progress-indicator/
created_at: 2025-11-19T08:43:12
---
# The Reusable Progress Indicator

## Reporting Progress Options

For optimized macros that take time to complete, progress reporting improves user experience. Several solutions exist.

### Updating Application.StatusBar

When users can continue using Excel while code runs, updating the application's status bar is optimal and non-disruptive:

```vba
Public Sub UpdateStatus(Optional ByVal msg As String = vbNullString)

    Dim isUpdating As Boolean
    isUpdating = Application.ScreenUpdating

    'we need ScreenUpdating toggled on to do this:
    If Not isUpdating Then Application.ScreenUpdating = True

    'if msg is empty, status goes to "Ready"
    Application.StatusBar = msg

    'make sure the update gets displayed (we might be in a tight loop)
    DoEvents

    'if ScreenUpdating was off, toggle it back off:
    Application.ScreenUpdating = isUpdating

End Sub
```

Critical consideration: users can change ActiveSheet at any time. Code with implicit or explicit active worksheet references will encounter problems. Rubberduck inspections can locate these implicit references.

### Modeless Progress Indicator

Common solutions display a modeless UserForm updated from worker code. This approach has disadvantages:

- Users can interact with the workbook and change ActiveSheet, but must drag the dialog to navigate
- Worker code is polluted with form member calls
- Worker code controls form display, hiding, and destruction
- Feels like a workaround instead of a proper modal solution

### "Smart UI" Modal Progress Indicator

For quick solutions, a "Smart UI" provides a modal dialog preventing workbook interaction during modifications. However, problems arise:

- Form runs the show with worker code in code-behind or invoked from it
- Reusing code in another project requires carefully extracting worker code
- Reusing code in the same project requires duplicating indicator code or implementing conditional logic for different modes
- Application logic coupled with UI cannot be unit tested
- Form cannot be reused for different functionality without considerable code-behind changes

## A Reusable Progress Indicator

The solution requires a modal indicator that doesn't run the show. The UserForm is responsible only for keeping its indicator representative of current progress.

Implementation uses two components: a form and a class module.

### ProgressView

The UserForm contains a ProgressLabel, a 228×24 DecorativeFrame, and a ProgressBar label using the Highlight color from the System palette.

```vba
Option Explicit
Private Const PROGRESSBAR_MAXWIDTH As Integer = 224
Public Event Activated()
Public Event Cancelled()

Private Sub UserForm_Activate()
    ProgressBar.Width = 0
    RaiseEvent Activated
End Sub

Public Sub Update(ByVal percentValue As Single, Optional ByVal labelValue As String, Optional ByVal captionValue As String)
    If labelValue  vbNullString Then ProgressLabel.Caption = labelValue
    If captionValue  vbNullString Then Me.Caption = captionValue
    ProgressBar.Width = percentValue * PROGRESSBAR_MAXWIDTH
    DoEvents
End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    If CloseMode = VbQueryClose.vbFormControlMenu Then
        Cancel = True
        RaiseEvent Cancelled
    End If
End Sub
```

This is not a Smart UI. The form has no concept of worker code and is unaware of its usage. Modally showing the default instance leaves only the VBE's "Stop" button to close it because the QueryClose handler prevents user closing. The form is responsible only for updating itself and notifying the ProgressIndicator when ready to start reporting progress or when the user cancels the operation.

### ProgressIndicator

This class is used by client code. A PredeclaredId attribute provides a default instance exposing a factory method.

```vba
Option Explicit

Private Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Private Const DEFAULT_CAPTION As String = "Progress"
Private Const DEFAULT_LABEL As String = "Please wait..."

Private Const ERR_NOT_INITIALIZED As String = "ProgressIndicator is not initialized."
Private Const ERR_PROC_NOT_FOUND As String = "Specified macro or object member was not found."
Private Const ERR_INVALID_OPERATION As String = "Worker procedure cannot be cancelled by assigning to this property."
Private Const VBERR_MEMBER_NOT_FOUND As Long = 438

Public Enum ProgressIndicatorError
    Error_NotInitialized = vbObjectError + 1001
    Error_ProcedureNotFound
    Error_InvalidOperation
End Enum

Private Type TProgressIndicator
    procedure As String
    instance As Object
    sleepDelay As Long
    canCancel As Boolean
    cancelling As Boolean
    currentProgressValue As Double
End Type

Private this As TProgressIndicator
Private WithEvents view As ProgressView

Private Sub Class_Initialize()
    Set view = New ProgressView
    view.Caption = DEFAULT_CAPTION
    view.ProgressLabel = DEFAULT_LABEL
End Sub

Private Sub Class_Terminate()
    Set view = Nothing
    Set this.instance = Nothing
End Sub

Private Function QualifyMacroName(ByVal book As Workbook, ByVal procedure As String) As String
    QualifyMacroName = "'" & book.FullName & "'!" & procedure
End Function

Public Function Create(ByVal procedure As String, Optional instance As Object = Nothing, Optional ByVal initialLabelValue As String, Optional ByVal initialCaptionValue As String, Optional ByVal completedSleepMilliseconds As Long = 1000, Optional canCancel As Boolean = False) As ProgressIndicator

    Dim result As ProgressIndicator
    Set result = New ProgressIndicator

    result.Cancellable = canCancel
    result.SleepMilliseconds = completedSleepMilliseconds

    If Not instance Is Nothing Then
        Set result.OwnerInstance = instance
    ElseIf InStr(procedure, "'!") = 0 Then
        procedure = QualifyMacroName(Application.ActiveWorkbook, procedure)
    End If

    result.ProcedureName = procedure

    If initialLabelValue  vbNullString Then result.ProgressView.ProgressLabel = initialLabelValue
    If initialCaptionValue  vbNullString Then result.ProgressView.Caption = initialCaptionValue

    Set Create = result

End Function

Friend Property Get ProgressView() As ProgressView
    Set ProgressView = view
End Property

Friend Property Get ProcedureName() As String
    ProcedureName = this.procedure
End Property

Friend Property Let ProcedureName(ByVal value As String)
    this.procedure = value
End Property

Friend Property Get OwnerInstance() As Object
    Set OwnerInstance = this.instance
End Property

Friend Property Set OwnerInstance(ByVal value As Object)
    Set this.instance = value
End Property

Friend Property Get SleepMilliseconds() As Long
    SleepMilliseconds = this.sleepDelay
End Property

Friend Property Let SleepMilliseconds(ByVal value As Long)
    this.sleepDelay = value
End Property

Public Property Get CurrentProgress() As Double
    CurrentProgress = this.currentProgressValue
End Property

Public Property Get Cancellable() As Boolean
    Cancellable = this.canCancel
End Property

Friend Property Let Cancellable(ByVal value As Boolean)
    this.canCancel = value
End Property

Public Property Get IsCancelRequested() As Boolean
    IsCancelRequested = this.cancelling
End Property

Public Sub AbortCancellation()
    Debug.Assert this.cancelling
    this.cancelling = False
End Sub

Public Sub Execute()
    view.Show vbModal
End Sub

Public Sub Update(ByVal percentValue As Double, Optional ByVal labelValue As String, Optional ByVal captionValue As String)

    On Error GoTo CleanFail
    ThrowIfNotInitialized

    ValidatePercentValue percentValue
    this.currentProgressValue = percentValue

    view.Update this.currentProgressValue, labelValue

CleanExit:
    If percentValue = 1 Then Sleep 1000 ' pause on completion
    Exit Sub

CleanFail:
    MsgBox Err.Number & vbTab & Err.Description, vbCritical, "Error"
    Resume CleanExit
End Sub

Public Sub UpdatePercent(ByVal percentValue As Double, Optional ByVal captionValue As String)
    ValidatePercentValue percentValue
    Update percentValue, Format$(percentValue, "0.0% Completed")
End Sub

Private Sub ValidatePercentValue(ByRef percentValue As Double)
    If percentValue > 1 Then percentValue = percentValue / 100
End Sub

Private Sub ThrowIfNotInitialized()
    If this.procedure = vbNullString Then
        Err.Raise ProgressIndicatorError.Error_NotInitialized, TypeName(Me), ERR_NOT_INITIALIZED
    End If
End Sub

Private Sub view_Activated()

    On Error GoTo CleanFail
    ThrowIfNotInitialized

    If Not this.instance Is Nothing Then
        ExecuteInstanceMethod
    Else
        ExecuteMacro
    End If

CleanExit:
    view.Hide
    Exit Sub

CleanFail:
    MsgBox Err.Number & vbTab & Err.Description, vbCritical, "Error"
    Resume CleanExit
End Sub

Private Sub ExecuteMacro()
    On Error GoTo CleanFail
    Application.Run this.procedure, Me

CleanExit:
    Exit Sub

CleanFail:
    If Err.Number = VBERR_MEMBER_NOT_FOUND Then
        Err.Raise ProgressIndicatorError.Error_ProcedureNotFound, TypeName(Me), ERR_PROC_NOT_FOUND
    Else
        Err.Raise Err.Number, Err.Source, Err.Description, Err.HelpFile, Err.HelpContext
    End If
    Resume CleanExit
End Sub

Private Sub ExecuteInstanceMethod()
    On Error GoTo CleanFail

    Dim parameter As ProgressIndicator
    Set parameter = Me 'Me cannot be passed to CallByName directly

    CallByName this.instance, this.procedure, VbMethod, parameter

CleanExit:
    Exit Sub

CleanFail:
    If Err.Number = VBERR_MEMBER_NOT_FOUND Then
        Err.Raise ProgressIndicatorError.Error_ProcedureNotFound, TypeName(Me), ERR_PROC_NOT_FOUND
    Else
        Err.Raise Err.Number, Err.Source, Err.Description, Err.HelpFile, Err.HelpContext
    End If
    Resume CleanExit
End Sub

Private Sub view_Cancelled()
    If Not this.canCancel Then Exit Sub
    this.cancelling = True
End Sub
```

The Create method is invoked from the default instance. For VBE pasting, use this header in notepad first:

```vba
VERSION 1.0 CLASS
BEGIN
 MultiUse = -1 'True
END
Attribute VB_Name = "ProgressIndicator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
```

Then paste the code underneath, save as ProgressIndicator.cls, and import into the VBE. The VB_Exposed attribute makes the class usable in other VBA projects. Friend members are inaccessible from external code.

The ProgressView is instantiated directly in Class_Initialize, creating tight coupling. Better design would inject an IProgressView interface through the Create method, but this requires complex event exposure gymnastics. The benefit would be loose coupling and enhanced testability with MockProgressView implementations.

The Create method takes a procedure name and sets the ProcedureName property. The procedure must be a Public Sub taking a ProgressIndicator parameter. If in a standard module, nothing else is needed. If in a class module, the instance parameter must be specified to invoke worker code off a class instance. Other parameters optionally configure initial caption and label. The canCancel parameter enables cancellation support.

The Execute method displays the modal form, triggering the Activated event. This validates a procedure exists, then invokes ExecuteInstanceMethod (given an instance) or ExecuteMacro, then Hides the view.

ExecuteMacro uses Application.Run to invoke the procedure. ExecuteInstanceMethod uses CallByName to invoke the member on the instance. Both pass Me as a parameter to the invoked procedure.

Worker code does the work and uses its ProgressIndicator parameter to Update progress and periodically check if the user wants to cancel. The AbortCancellation method can cancel the cancellation if needed.

### Client & Worker Code

Client code registers the worker procedure and executes it through the ProgressIndicator instance:

```vba
Public Sub DoSomething()
    With ProgressIndicator.Create("DoWork", canCancel:=True).Execute
    End With
End Sub
```

This registers the DoWork worker procedure and executes it. DoWork is any Public Sub in a standard module taking a ProgressIndicator parameter:

```vba
Public Sub DoWork(ByVal progress As ProgressIndicator)
    Dim i As Long
    For i = 1 To 10000
        If ShouldCancel(progress) Then
            'here more complex worker code could rollback & cleanup
            Exit Sub
        End If
        ActiveSheet.Cells(1, 1) = i
        progress.Update i / 10000
    Next
End Sub

Private Function ShouldCancel(ByVal progress As ProgressIndicator) As Boolean
    If progress.IsCancelRequested Then
        If MsgBox("Cancel this operation?", vbYesNo) = vbYes Then
            ShouldCancel = True
        Else
            progress.AbortCancellation
        End If
    End If
End Function
```

The Create method can also register a method in a class module, given a class instance:

```vba
Public Sub DoSomething()
    Dim foo As SomeClass
    Set foo = New SomeClass
    With ProgressIndicator.Create("DoWork", foo).Execute
    End With
End Sub
```

## Considerations

To use this ProgressIndicator solution as an Excel add-in, rename the VBA project (e.g., ReusableProgress) to avoid confusion when referencing a project named "VBAProject" from another "VBAProject."

This solution adapts to any VBA host application by removing standard module support and only invoking worker code in class modules with CallByName.

## Conclusion

A reusable progress indicator eliminates the need for reimplementation. After implementing once, it can be used in 200 places across 100 projects. No code in ProgressIndicator or ProgressView classes needs to change. Only worker code needs to be written, and worker code focuses solely on its job.
