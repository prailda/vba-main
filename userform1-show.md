---
id: 995F-2FFE-E4BA-41C8-AFFF-99B7-D21C-3021
name: userform1-show
title: UserForm1.Show
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
url: https://rubberduckvba.blog/2017/10/25/userform1-show/
created_at: 2025-11-19T08:43:14
---
# UserForm1.Show

## Default Instance Understanding

Many tutorials demonstrate UserForm1.Show without explaining the implications of using a form's default instance for code quality and programming concept understanding. Most don't explain the default instance concept.

Without understanding, the result is code that abstracts away crucially important concepts, leading to future problems.

### What's that default instance anyway?

A UserForm is essentially a class module with a designer and a VB_PredeclaredId attribute. That PredeclaredId means VBA automatically creates a global-scope instance of the class, named after that class. If the default instance is ever unloaded or set to Nothing, its internal state gets reset and automatically reinitializes when the default instance is invoked again. `Set UserForm1 = Nothing` can be executed repeatedly, but `UserForm1 Is Nothing` always evaluates to False. A default instance is useful for exposing a factory method, but don't Show the default instance.

## Doing It Wrong

Red flags invariably raised in many UserForm tutorials:

- `Unload Me` or worse, `Unload UserForm1` in the form's code-behind. The former makes the form instance self-destructing. The latter destroys/resets the default instance, not necessarily the executing instance, leading to unexpected behavior and duplicate Stack Overflow questions.
- `UserForm1.Show` at the call site, where UserForm1 is the default instance rather than a local variable. This uses an object without realizing it (without New-ing it up) and stores state belonging to a global instance, using an object without object-oriented programming benefits. This also means...
- Application logic is implemented in the form's code-behind. This "smart UI" anti-pattern couples logic with UI. Any logic beyond displaying and collecting data performs someone else's job. That logic becomes coupled with UI and impossible to unit test. The form cannot be reused for something else in the same project (or similar functionality in another project) without considerable code-behind changes. A form used in 20 places running 20 functionalities inevitably becomes a spaghetti mess.

## Doing it right

At the call site, show an instance of the form, let the user interact, and when the dialog closes, the calling code pulls data from the form's state. This requires avoiding a self-destructing form that wipes out state before the [Ok] button's Click handler returns.

### Hide it, don't Unload it

In .NET's Windows Forms UI framework (WinForms/the .NET successor of MSForms), a form's Show method is a function returning a DialogResult enum value, like MsgBox does. This makes sense: the Show method tells its caller what the user meant to do with the form's state: Ok being the green light to process it, Cancel meaning the user chose not to proceed.

Showing a dialog isn't fire-and-forget business. If the caller is responsible for knowing what to do when the form is okayed or cancelled, it needs to know whether the form was okayed or cancelled.

A form can't tell its caller anything if clicking [Ok] nukes the form object.

Basic code-behind for a form with [Ok] and [Cancel] buttons:

```vba
Option Explicit
'@Folder("UI")
Private cancelled As Boolean

Public Property Get IsCancelled() As Boolean
    IsCancelled = cancelled
End Property

Private Sub OkButton_Click()
    Hide
End Sub

Private Sub CancelButton_Click()
    OnCancel
End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    If CloseMode = VbQueryClose.vbFormControlMenu Then
        Cancel = True
        OnCancel
    End If
End Sub

Private Sub OnCancel()
    cancelled = True
    Hide
End Sub
```

Two ways to cancel the dialog exist: the [Cancel] button and the [X] button. The [X] button would nuke the object instance if `Cancel = True` wasn't specified in the QueryClose handler. Handling QueryClose is fundamental. Without it, even without Unload-ing anywhere, [X]-ing out will cause issues because calling code doesn't expect a self-destructing object. The form's object reference must be available for the caller to verify if the form was cancelled when .Show returns.

Calling code:

```vba
With New UserForm1
    .Show
    If Not .IsCancelled Then
        '...
    End If
End With
```

No local variable declaration is needed. The `With New` syntax yields the object reference to the With block, which properly destroys the object when the With block is exited. GoTo-jumping out and back into a With block is inadvisable. This can happen accidentally with a Resume or Resume Next instruction in error-handling.

### The Model

A dialog displays and collects data. If the caller needs to know UserName and Password, it doesn't need to care about userNameBox and passwordBox textbox controls. It cares about the UserName and Password the user provided. The controls themselves (ability to hide, move, resize, change font and border style) are utterly irrelevant. The calling code doesn't need controls; it needs a model that encapsulates the form's data.

In simplest form, the model can be a few Property Get members in the form's code-behind:

```vba
Public Property Get UserName() As String
    UserName = userNameBox.Text
End Property

Public Property Get Password() As String
    Password = passwordBox.Text
End Property
```

Better, it could be a full-fledged class exposing Property Get and Property Let members for every property.

Calling code can now get the form's data without needing to care about controls or knowing UserName was entered in a TextBox control or knowing Password without knowing the PasswordChar for passwordBox was set to `*`.

However, form controls are basically public instance fields on the form object. The caller can access them at will, making UserName and Password properties lost in a sea of MSForms boilerplate in IntelliSense. So implement the model in its own class module instead, using composition to encapsulate it:

```vba
Private viewModel As LoginDialogModel

Public Property Get Model() As LoginDialogModel
    Set Model = viewModel
End Property

Public Property Set Model(ByVal value As LoginDialogModel)
    Set viewModel = value
End Property
```

The model could be updated by textboxes and even expose Boolean properties to enable/disable the [Ok] button or show/hide validation error icons:

```vba
Private Sub userNameBox_Change()
    viewModel.UserName = userNameBox.Text
    ValidateForm
End Sub

Private Sub passwordBox_Change()
    viewModel.Password = passwordBox.Text
    ValidateForm
End Sub

Private Sub ValidateForm()
    okButton.Enabled = viewModel.IsValidModel
    userNameValidationErrorIcon.Visible = viewModel.IsInvalidUserName
    passwordValidationErrorIcon.Visible = viewModel.IsInvalidPassword
End Sub
```

A problem remains: the caller doesn't want to see the form's controls.

### The View

A model abstraction exists that the view can consume, but no abstraction exists for the view. Add a new class module defining a general-purpose IView interface:

```vba
Option Explicit
'@Folder("Abstractions")
'@Interface

Public Function ShowDialog(ByVal viewModel As Object) As Boolean
End Function
```

The form can implement that interface. Because the interface exposes the ShowDialog method, a public IsCancelled property is no longer needed. Introducing a Private Type:

```vba
Option Explicit
Implements IView
'@Folder("UI")

Private Type TView
    IsCancelled As Boolean
    Model As LoginDialogModel
End Type

Private this As TView

Private Sub OkButton_Click()
    Hide
End Sub

Private Sub CancelButton_Click()
    OnCancel
End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    If CloseMode = VbQueryClose.vbFormControlMenu Then
        Cancel = True
        OnCancel
    End If
End Sub

Private Sub OnCancel()
    this.IsCancelled = True
    Hide
End Sub

Private Function IView_ShowDialog(ByVal viewModel As Object) As Boolean
    Set this.Model = viewModel
    Show
    IView_ShowDialog = Not cancelled
End Function
```

The interface can't be general-purpose if the Model property is more specific than Object, but this doesn't matter. The code-behind gets IntelliSense and early-bound, compile-time validation of member calls against it because the Private viewModel field is an implementation detail. This particular IView implementation is a "login dialog" with a LoginDialogModel; the interface doesn't need to know, only the implementation.

The [Ok] button will only be enabled if the model is valid, reducing caller concerns. The logic addressing that concern is neatly encapsulated in the model class itself.

The calling code supplies the model, so its type is known to the caller. The Property Get member is provided as a convenience because it makes little sense to Set a property without being able to Get it later.

With a Self property added to the model class (`Set Self = Me`), calling code could look like:

```vba
Public Sub Test()
    Dim view As IView
    Set view = New LoginForm

    With New LoginDialogModel
        If Not view.ShowDialog(.Self) Then Exit Sub
        'consume the model:
        Debug.Print .UserName, .Password
    End With 'model goes out of scope

End Sub 'view goes out of scope
```

This IView interface could be implemented by a MockLoginDialog class implementing ShowDialog by returning a test-configured value. Unit tests could be written against any code consuming an IView rather than an actual LoginForm, provided the calling code is responsible for knowing what specific IView implementation the code will interact with.

The model's validation logic could be unit-tested:

```vba
Const value As String = "1234"
With New LoginDialogModel
    .Password = value
    Assert.IsTrue .IsInvalidPassword, "'" & value & "' should be invalid."
End With
```

With a Model and a View, the next step is implementing a Presenter class, an abstraction completing the MVP pattern, a much more robust way to write UI-involving code than a Smart UI.
