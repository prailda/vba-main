---
id: 77F4-FE74-3B16-44BD-8295-C014-5D49-274E
name: model-view-viewmodel
title: Model, View, ViewModel
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
url: https://rubberduckvba.blog/2020/09/13/model-view-viewmodel/
created_at: 2025-11-19T08:43:07
---
# Model, View, ViewModel

Model-View-Presenter (MVP) enhances testability but introduces drawbacks: View code-behind contains noisy event handlers and boilerplate, and View-Presenter communication feels clunky.

Windows Presentation Foundation (WPF) redefines UI programming with XML/markup-based (XAML) design. The most compelling element is data binding capabilities.

VBA can leverage what makes Model-View-ViewModel (MVVM) effective in C# without writing entire UI frameworks. Abstract infrastructure enables this. The proof-of-concept works at current stage.

### Overview

The result is extremely decoupled, extensible, completely testable architecture. Every user action (command) is formally defined, programmatically simulated/tested with real, stubbed, or faked dependencies, and bound to multiple UI elements or programmatically executed.

#### MVVM Quick Checklist

Component relationship rules:
- View (UserForm) knows ViewModel, not Model
- ViewModel knows commands, not View
- Model knows neither View nor ViewModel; exists independently

### Commands

Commands are objects implementing `ICommand`:

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

For `CommandBinding`, `Context` parameter is always DataContext/ViewModel. Manual invocations could supply other parameters. Not all implementations need ViewModel; `CanExecute` returning `True` is often sufficient. `Description` sets tooltips on command binding target UI elements.

Command implementations range from simple to complex. Commands may have dependencies. `ReloadCommand` might receive `IDbContext` injection exposing `SelectAllTheThings` functions pulling database data or generating hard-coded strings. Commands should not know data sources or acquisition methods.

Each command is its own class encapsulating enable/disable logic and execution. UserForm modules contain only presentation concerns.

Infrastructure provides `AcceptCommand` and `CancelCommand` implementations for [Ok], [Cancel], or [Close] dialog buttons.

#### AcceptCommand

```vba
'@PredeclaredId
Option Explicit
Implements ICommand

Private Type TState
    View As IView
End Type

Private this As TState

Public Function Create(ByVal View As IView) As ICommand
    Dim result As AcceptCommand
    Set result = New AcceptCommand
    Set result.View = View
    Set Create = result
End Function

Public Property Get View() As IView
    Set View = this.View
End Property

Public Property Set View(ByVal RHS As IView)
    Set this.View = RHS
End Property

Private Function ICommand_CanExecute(ByVal Context As Object) As Boolean
    Dim ViewModel As IViewModel
    If TypeOf Context Is IViewModel Then
        Set ViewModel = Context
        If Not ViewModel.Validation Is Nothing Then
            ICommand_CanExecute = ViewModel.Validation.IsValid
            Exit Function
        End If
    End If
    ICommand_CanExecute = True
End Function

Private Property Get ICommand_Description() As String
    ICommand_Description = "Accept changes and close."
End Property

Private Sub ICommand_Execute(ByVal Context As Object)
    this.View.Hide
End Sub
```

#### CancelCommand

Similar to `AcceptCommand`, invoking View methods. Enhancement opportunities include tracking "dirty" state and prompting users about discarding unsaved changes.

```vba
'@PredeclaredId
'@Exposed
Option Explicit
Implements ICommand

Private Type TState
    View As ICancellable
End Type

Private this As TState

Public Function Create(ByVal View As ICancellable) As ICommand
    Dim result As CancelCommand
    Set result = New CancelCommand
    Set result.View = View
    Set Create = result
End Function

Public Property Get View() As ICancellable
    Set View = this.View
End Property

Public Property Set View(ByVal RHS As ICancellable)
    Set this.View = RHS
End Property

Private Function ICommand_CanExecute(ByVal Context As Object) As Boolean
    ICommand_CanExecute = True
End Function

Private Property Get ICommand_Description() As String
    ICommand_Description = "Cancel pending changes and close."
End Property

Private Sub ICommand_Execute(ByVal Context As Object)
    this.View.OnCancel
End Sub
```

Command pattern implementation guidelines:
- Classes can have `@PredeclaredId` annotations exposing factory methods for property-injecting dependencies
- All commands require user-facing descriptions as tooltips on binding targets (typically `CommandButton`)
- `CanExecute` can unconditionally return `True` or be complex with ViewModel context access; methods should perform well and return quickly

By implementing UI commands as `ICommand` objects, View and ViewModel remain free of command logic and `Click` handlers. The command pattern achieves low coupling and high cohesion: small, specialized modules depending on injectable abstractions.

### Property Bindings

XAML uses markup extensions binding ViewModel property values to UI element properties:

```xml
<TextBox Text="{Binding SomeProperty, Mode=TwoWay, UpdateSourceTrigger=PropertyChanged}" />
```

ViewModels implementing `INotifyPropertyChanged` firing `PropertyChanged` events enable WPF to automatically synchronize UI with ViewModel and vice versa.

MVVM with MSForms in VBA lacks special string syntax but encapsulates `PropertyBinding` concept into objects. At core, bindings comprise: source, target, and update methods.

Binding terminology:
- Source: ViewModel
- SourcePropertyPath: ViewModel property name
- Target: MSForms control
- TargetProperty: MSForms control property name

`SourcePropertyPath` resolves recursively, supporting property chains.

```vba
.BindPropertyPath ViewModel, "SourcePath", Me.PathBox, _
    Validator:=New RequiredStringValidator, _
    ErrorFormat:=AggregateErrorFormatter.Create(ViewModel, _
        ValidationErrorFormatter.Create(Me.PathBox) _.WithErrorBackgroundColor _.WithErrorBorderColor)
```

`IBindingManager.BindPropertyPath` accepts optional parameters with sensible defaults for common MSForms controls' default property bindings. For example, `MSForms.TextBox` automatically binds to `Text` property without specifying `TargetProperty`.

BindingMode enum values:
- TwoWayBinding: Updates source when target changes and vice versa
- OneWayBinding: Updates target when source changes
- OneWayToSource: Updates source when target changes
- OneTimeBinding: Updates target once

UpdateSourceTrigger enum values:
- OnPropertyChanged: Updates when bound property changes
- OnKeyPress: Updates source at each keypress (TextBox only); data validation may prevent keypresses
- OnExit: Updates source before target loses focus; data validation may cancel exit

#### Property Paths

Binding managers recursively resolve member paths. If ViewModel has `ThingSection` property (itself a ViewModel with bindings/commands) containing `Thing` property, binding path can be `ThingSection.Thing`. If `ThingSection` is `Nothing`, target receives default values depending on type.

#### Data Validation

Property bindings attach `IValueValidator` implementations encapsulating specialized validation rules:

```vba
'@Folder MVVM.Example
Option Explicit
Implements IValueValidator

Private Function IValueValidator_IsValid(ByVal Value As Variant, ByVal Source As Object, ByVal Target As Object) As Boolean
    IValueValidator_IsValid = Len(Trim$(Value)) > 0
End Function

Private Property Get IValueValidator_Message() As String
    IValueValidator_Message = "Value cannot be empty."
End Property
```

`IsValid` receives `Value`, binding `Source`, and binding `Target` objects, providing ViewModel access. Functions should avoid side-effects. Avoid mutating ViewModel properties in validators, though messages can be dynamically constructed with module-level state (preferably avoided).

#### Presenting Validation Errors

`ValidationErrorFormatter` meets most scenarios. Factory methods create instances with specific target UI elements, chaining builder method calls for fluent inline configuration:

```vba
Set Formatter = ValidationErrorFormatter.Create(Me.PathBox) _.WithErrorBackgroundColor(vbYellow) _.WithErrorBorderColor
```

Builder methods:
- Create: Factory method ensuring instances created with target UI elements
- WithErrorBackgroundColor: Sets different background color for validation errors (default: light red)
- WithErrorBorderColor: Sets different border color for validation errors (default: dark red); no effect on non-flat-style or non-fixed-single borders
- WithErrorForeColor: Sets different fore (text) color for validation errors (default: dark red)
- WithErrorFontBold: Applies bold font weight for validation errors
- WithTargetOnlyVisibleOnError: Hides target normally, showing only on validation errors; useful for label/icon controls

`AggregateErrorFormatter` ties multiple `ValidationErrorFormatter` instances (multiple target controls) to single bindings.

#### Value Converters

`IBindingManager.BindPropertyPath` accepts optional `IValueConverter` parameters for source-target or target-source conversions. `InverseBooleanConverter` converts `True` in source to `False` in target.

Interfaces mandate `Convert` and `ConvertBack` functions for target-bound and source-bound values. Pure functions and performant implementations preferred over side-effecting code.

```vba
'@PredeclaredId
'@Exposed
Option Explicit
Implements IValueConverter

Public Function Default() As IValueConverter
    Set Default = InverseBooleanConverter
End Function

Private Function IValueConverter_Convert(ByVal Value As Variant) As Variant
    IValueConverter_Convert = Not CBool(Value)
End Function

Private Function IValueConverter_ConvertBack(ByVal Value As Variant) As Variant
    IValueConverter_ConvertBack = Not CBool(Value)
End Function
```

Single-directional bindings need not make both functions return sensible round-trip values.

### ViewModel

Every ViewModel class is application-specific. Recurring themes:
- View fields bind to ViewModel properties; ViewModels quickly grow numerous properties
- Property changes propagate to "main" ViewModel (data context) by firing `PropertyChanged` events
- Register command bindings with `CommandManager` implementing `IHandlePropertyChanged`

ViewModels implement at least:
- IViewModel: Provides validation error handler access
- INotifyPropertyChanged: Notifies data bindings of property changes

Example implementation:

```vba
'@PredeclaredId
Implements IViewModel
Implements INotifyPropertyChanged
Option Explicit

Public Event PropertyChanged(ByVal Source As Object, ByVal PropertyName As String)

Private Type TViewModel
    Handlers As Collection
    SomeCommand As ICommand
    SourcePath As String
    SomeOption As Boolean
    SomeOtherOption As Boolean
End Type

Private this As TViewModel
Private WithEvents ValidationHandler As ValidationManager

Public Function Create() As IViewModel
    Dim result As ExampleViewModel
    Set result = New ExampleViewModel
    Set Create = result
End Function

Public Property Get Validation() As IHandleValidationError
    Set Validation = ValidationHandler
End Property

Public Property Get SourcePath() As String
    SourcePath = this.SourcePath
End Property

Public Property Let SourcePath(ByVal RHS As String)
    If this.SourcePath <> RHS Then
        this.SourcePath = RHS
        OnPropertyChanged "SourcePath"
    End If
End Property

Private Sub OnPropertyChanged(ByVal PropertyName As String)
    RaiseEvent PropertyChanged(Me, PropertyName)
    Dim Handler As IHandlePropertyChanged
    For Each Handler In this.Handlers
        Handler.OnPropertyChanged Me, PropertyName
    Next
End Sub

Private Sub Class_Initialize()
    Set this.Handlers = New Collection
    Set ValidationHandler = ValidationManager.Create
End Sub

Private Sub INotifyPropertyChanged_OnPropertyChanged(ByVal Source As Object, ByVal PropertyName As String)
    OnPropertyChanged PropertyName
End Sub

Private Sub INotifyPropertyChanged_RegisterHandler(ByVal Handler As IHandlePropertyChanged)
    this.Handlers.Add Handler
End Sub

Private Property Get IViewModel_Validation() As IHandleValidationError
    Set IViewModel_Validation = ValidationHandler
End Property

Private Sub ValidationHandler_PropertyChanged(ByVal Source As Object, ByVal PropertyName As String)
    OnPropertyChanged PropertyName
End Sub
```

ViewModels expose properties for View binding, firing `PropertyChanged` events keeping UI controls synchronized.

### View

UserForm code-behind example:

```vba
'@Folder MVVM.Example
Implements IView
Implements ICancellable
Option Explicit

Private Type TView
    ViewModel As ExampleViewModel
    IsCancelled As Boolean
    Bindings As IBindingManager
End Type

Private this As TView

Public Function Create(ByVal ViewModel As ExampleViewModel, ByVal Bindings As IBindingManager) As IView
    Dim result As ExampleView
    Set result = New ExampleView
    Set result.Bindings = Bindings
    Set result.ViewModel = ViewModel
    Set Create = result
End Function

Public Property Get ViewModel() As ExampleViewModel
    Set ViewModel = this.ViewModel
End Property

Public Property Set ViewModel(ByVal RHS As ExampleViewModel)
    Set this.ViewModel = RHS
    InitializeBindings
End Property

Public Property Get Bindings() As IBindingManager
    Set Bindings = this.Bindings
End Property

Public Property Set Bindings(ByVal RHS As IBindingManager)
    Set this.Bindings = RHS
End Property

Private Sub BindViewModelCommands()
    With Bindings.BindCommand ViewModel, Me.OkButton, AcceptCommand.Create(Me).BindCommand ViewModel, Me.CancelButton, CancelCommand.Create(Me).BindCommand ViewModel, Me.BrowseButton, ViewModel.SomeCommand
    End With
End Sub

Private Sub BindViewModelProperties()
    With Bindings.BindPropertyPath ViewModel, "SourcePath", Me.PathBox, _
            Validator:=New RequiredStringValidator, _
            ErrorFormat:=AggregateErrorFormatter.Create(ViewModel, _
                ValidationErrorFormatter.Create(Me.PathBox).WithErrorBackgroundColor.WithErrorBorderColor).BindPropertyPath ViewModel, "Instructions", Me.InstructionsLabel.BindPropertyPath ViewModel, "SomeOption", Me.OptionButton1.BindPropertyPath ViewModel, "SomeOtherOption", Me.OptionButton2
    End With
End Sub

Private Sub InitializeBindings()
    If ViewModel Is Nothing Then Exit Sub
    BindViewModelProperties
    BindViewModelCommands
    Bindings.ApplyBindings ViewModel
End Sub

Private Sub OnCancel()
    this.IsCancelled = True
    Me.Hide
End Sub

Private Property Get ICancellable_IsCancelled() As Boolean
    ICancellable_IsCancelled = this.IsCancelled
End Property

Private Sub ICancellable_OnCancel()
    OnCancel
End Sub

Private Sub IView_Hide()
    Me.Hide
End Sub

Private Sub IView_Show()
    Me.Show vbModal
End Sub

Private Function IView_ShowDialog() As Boolean
    Me.Show vbModal
    IView_ShowDialog = Not this.IsCancelled
End Function

Private Property Get IView_ViewModel() As Object
    Set IView_ViewModel = this.ViewModel
End Property
```

VBA has had the ability to make this pattern work all along.
