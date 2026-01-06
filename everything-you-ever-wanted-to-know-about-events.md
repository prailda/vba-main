---
id: 8229-10B5-F300-4F44-A0B1-62DB-7642-B5E9
name: everything-you-ever-wanted-to-know-about-events
title: Everything You Ever Wanted To Know About Events
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
url: https://rubberduckvba.blog/2019/03/27/everything-you-ever-wanted-to-know-about-events/
created_at: 2025-11-19T08:43:04
---
# Everything You Ever Wanted To Know About Events

VBA operates as an event-driven language. Worksheet automation executes code in response to workbook or worksheet events. ActiveX controls like `MSForms.CommandButton` trigger code through event handlers such as `CommandButton1_Click`.

### Asynchronous Code

Procedural paradigms execute statements sequentially: procedure A invokes procedure B, procedure B completes, execution returns to procedure A, procedure A completes, execution ends.

Event-driven paradigms execute statements sequentially but external objects invoke procedures. Compile-time determination of run-time sequence is impossible. UserForm code-behind with `Button1` and `Button2` controls cannot predict whether `Button1_Click` executes before `Button2_Click`, or if either executes. Event raising drives code execution.

Event-driven code executes asynchronously. Loop bodies can be interrupted when `DoEvents` statements enable Excel responsiveness. Selected cell changes might trigger worksheet event handlers mid-loop. Handler completion resumes loop execution.

This mechanism proves useful in object-oriented projects, as only class modules raise and handle events. The OOP BattleShip project extensively uses event forwarding and interface-exposed events (see GridViewAdapter and WorksheetView classes).

### Host Document & Other Built-In Events

VBA code resides in host documents awaiting execution. Standard module public parameterless procedures serve as entry points, appearing in macro lists and attachable to shapes for user-triggered invocation.

Host documents provide "hooks" executing VBA code during specific operations (opening, saving, modifying documents). Different hosts expose varying granularity and quantity of event hooks. These hooks are events exposed by the host application's object model; procedures executed when events raise are event handler procedures.

#### Document Modules

Excel's host document is represented by a `Workbook` module named `ThisWorkbook`; worksheets are represented by `Worksheet` modules. These document modules are special class modules inheriting base classes: `ThisWorkbook` class is-a `Workbook` class; `Sheet1` class is-a `Worksheet` class. "Is-a" relationships indicate class inheritance (versus "has-a" composition). Document modules are special because host applications control instantiation (cannot execute `Set foo = New Worksheet`), and like `UserForm` modules, they inherit base class members. Typing `Me.` in `Sheet1` procedures provides access to inherited `Me.Range` property from the `Worksheet` base class, or `Me.Controls` in `UserForm1` from the `UserForm` class.

##### VBA Inheritance Support

VBA user code lacks inheritance mechanisms (no `Inherits` keyword). VBA creates and consumes COM types with inheritance hierarchies.

Alternatively, the `ThisWorkbook: Workbook` relationship can be pictured as composition (`Private WithEvents Workbook As Workbook`) rather than inheritance.

##### Events

`Sheet1` modules inherit the `Worksheet` class, accessing events defined in that class. The Object Browser (F2) displays available events with lightning bolt icons.

`Worksheet` modules implement event handlers for base `Worksheet` class events. Event handlers require correct signatures: procedure names, parameter counts, orders, and types must match event definitions. The VBE generates correctly-signed procedures automatically through dropdown selections at the code pane top.

Event handler procedures are **Private**. Event handlers serve as callbacks invoked by the VBA runtime, not user code. Limiting logic in event handler procedures and delegating work to separate dedicated procedures enables public procedures invocable from elsewhere. This is critical for `UserForm` modules accessed outside form code-behind.

Event handler naming follows specific patterns like interface implementations:

```vba
Private Sub EventProvider_EventName()
```

The underscore matters syntactically. Avoiding underscores in procedure names and using `PascalCase` prevents headaches when defining and implementing interfaces. Attempting to implement interfaces with underscore-containing member names causes compilation failures.

### Custom Events

VBA class modules define custom events. Events are defined only in class modules (document and userform modules are classes). The `Event` keyword defines events:

```vba
Public Event BeforeSomething(ByRef Cancel As Boolean)
Public Event AfterSomething()
```

Events should be `Public` for external class handling. The `RaiseEvent` keyword raises events:

```vba
Public Sub DoSomething()
    Dim cancelling As Boolean
    RaiseEvent BeforeSomething(cancelling)
    If Not cancelling Then
        'do stuff...
        RaiseEvent AfterSomething
    End If
End Sub
```

Event design guidelines:
- Define `Before`/`After` event pairs raised before and after operations, enabling handlers to execute preparatory/cleanup code.
- Provide `ByRef Cancel As Boolean` parameters in `Before` events, letting handlers determine operation cancellation.
- Consider using `ByVal Cancel As MSForms.ReturnBoolean` when MSForms type library is referenced. This object encapsulates cancel state, passing by value while treating as `Boolean` through the `Value` default member.
- Consider exposing public `On[EventName]` procedures with event signatures raising said events. Events raise only within defining classes, making such methods useful for testing.
- Use past tense indicating events occurring after operations complete when no before-event is needed. Example: `Changed` instead of `Change`.
- Use future tense indicating events occurring before operations start when no after-event is needed. Example: `WillConnect`.
- Avoid present tense (indicative or progressive/continuous) due to ambiguity about event timing. Standard library events use this scheme, creating uncertainty about whether events fire before or after changes occur.
- Avoid `Before` or `After` without corresponding `After`/`Before` events.
- Prioritize consistency over rigid adherence to guidelines.

Classes defining events are providers; classes handling events are clients. Client code declares `WithEvents` fields. These fields must be early-bound; available types are event providers (classes exposing at least one event).

```vba
Option Explicit
Private WithEvents foo As Something

Private Sub foo_BeforeDoSomething(ByRef Cancel As Boolean)
    'handles Something.DoSomething
End Sub
```

Every `WithEvents` field adds items to the left-hand code pane dropdown, with that class's events in the right-hand dropdown, identical to workbook or worksheet events.
