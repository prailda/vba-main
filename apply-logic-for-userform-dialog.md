---
id: 69AD-53E6-3B13-47E8-B9A8-AB6E-B7E7-4734
name: apply-logic-for-userform-dialog
title: 'Apply' logic for UserForm dialog
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
url: https://rubberduckvba.blog/2018/05/08/apply-logic-for-userform-dialog/
created_at: 2025-11-19T08:43:16
---
# 'Apply' logic for UserForm dialog

Extending UserForm dialog patterns to include "Apply" button functionality requires raising events and handling them in presenter classes.

The dialog contains two textboxes and three buttons (Accept, Apply, Cancel). The Model class (`ExampleModel`) exposes properties manipulated by textboxes:

```vba
Option Explicit

Private Type TModel
    field1 As String
    field2 As String
End Type

Private this As TModel

Public Property Get field1() As String
    field1 = this.field1
End Property

Public Property Let field1(ByVal value As String)
    this.field1 = value
End Property

Public Property Get field2() As String
    field2 = this.field2
End Property

Public Property Let field2(ByVal value As String)
    this.field2 = value
End Property
```

The `IDialogView` interface passes models as `Object` (avoiding tight coupling with `ExampleModel`). The contract: provide a model, display a dialog, return `True` unless cancelled:

```vba
Option Explicit

Public Function ShowDialog(ByVal viewModel As Object) As Boolean
End Function
```

The form's code-behind implements `IDialogView` and stores `ExampleModel` references. The `Public Event ApplyChanges` event raises when users click "apply":

```vba
Option Explicit

Public Event ApplyChanges(ByVal viewModel As ExampleModel)

Private Type TView
    IsCancelled As Boolean
    Model As ExampleModel
End Type
Private this As TView

Implements IDialogView

Private Sub AcceptButton_Click()
    Me.Hide
End Sub

Private Sub ApplyButton_Click()
    RaiseEvent ApplyChanges(this.Model)
End Sub

Private Sub CancelButton_Click()
    OnCancel
End Sub

Private Sub Field1Box_Change()
    this.Model.field1 = Field1Box.value
End Sub

Private Sub Field2Box_Change()
    this.Model.field2 = Field2Box.value
End Sub

Private Sub OnCancel()
    this.IsCancelled = True
    Me.Hide
End Sub

Private Function IDialogView_ShowDialog(ByVal viewModel As Object) As Boolean
    Set this.Model = viewModel
    Me.Show vbModal
    IDialogView_ShowDialog = Not this.IsCancelled
End Function

Private Sub UserForm_Activate()
    Field1Box.value = this.Model.field1
    Field2Box.value = this.Model.field2
End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    If CloseMode = VbQueryClose.vbFormControlMenu Then
        Cancel = True
        OnCancel
    End If
End Sub
```

The Presenter class handles the event processing. The `Show` method optionally accepts initial model data. The form handles its `Activate` event to synchronize form controls with model values:

```vba
Option Explicit
Private WithEvents view As ExampleDialog

Private Property Get Dialog() As IDialogView
    Set Dialog = view
End Property

Public Sub Show(Optional ByVal field1 As String, Optional ByVal field2 As String)

    Set view = New ExampleDialog

    Dim viewModel As ExampleModel
    Set viewModel = New ExampleModel
    viewModel.field1 = field1
    viewModel.field2 = field2

    If Dialog.ShowDialog(viewModel) Then ApplyChanges viewModel
    Set view = Nothing

End Sub

Private Sub view_ApplyChanges(ByVal viewModel As ExampleModel)
    ApplyChanges viewModel
End Sub

Private Sub ApplyChanges(ByVal viewModel As ExampleModel)
    Sheet1.Range("A1").value = viewModel.field1
    Sheet1.Range("A2").value = viewModel.field2
End Sub
```

The `Private WithEvents` field gets assigned in `Show`, handling the form's `ApplyChanges` event by invoking `ApplyChanges` logic. This example writes two fields to Sheet1 A1 and A2. Introducing interfaces decouples worksheets from presenters, enabling writing to worksheets, text files, or databases without presenter knowledge of implementation details.

Calling code:

```vba
Option Explicit

Public Sub ExampleMacro()
    With New ExamplePresenter.Show "test"
    End With
End Sub
```

The View implementation couples with the presenter (the presenter creates the view). Concrete UserForm types are required for VBA to recognize events. Passing `IDialogView` implementations to presenter logic without displaying actual dialogs requires additional abstraction. The Adapter Pattern solves this problem by introducing more interfaces.
