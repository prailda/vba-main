---
id: 430C-3785-974A-41DE-88F0-10B0-7AE6-C291
name: the-macro-recorder-curse
title: The Macro Recorder Curse
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
url: https://rubberduckvba.blog/2019/06/30/the-macro-recorder-curse/
created_at: 2025-11-19T08:43:12
---
# The Macro Recorder Curse

## Early Binding and Guard Clauses

From an automation standpoint, Selection is an interesting object. In the Excel object model, Selection can be a selected Shape, a clicked Chart, or navigated Range of cells. If the current selection is relevant to code, consider making it an input with an explicit object type. The expected selection very likely has a specific type, like Range.

```vba
Public Sub MyMacro()
    Selection.Value = 42 'multiple possible errors
End Sub
```

If Selection is pulled from code and taken as a Range parameter, all ambiguities are eliminated by coding against the Range interface rather than Object, enabling compile-time validation and IntelliSense:

```vba
Public Sub MyMacro()
    If Not TypeOf Selection Is Excel.Range Then Exit Sub '<~ that's a *guard clause*
    DoSomething Selection
End Sub

Private Sub DoSomething(ByVal target As Range)
    target.Value = 42
End Sub
```

The difference between MyMacro in the first snippet and DoSomething in the second is what they do differently. The procedure can now work with any Range object, whether actually selected or not.

Working with Selection is never required. What can be done against Selection can be done with any Range if working with a Range, or any Chart if working with a Chart.

Binding these types at compile-time simplifies code significantly. When making member calls against Object, the compiler doesn't verify member existence. This involves runtime overhead and a non-zero chance of error 438 when the member doesn't exist. Like Variant, Object is too flexible for its own good.

A member call against Selection is inherently late-bound. Like dynamic in C#, breaking out of late binding as soon as possible is advisable. If expecting a Range, declare a Range and be explicit. VBA will raise a type mismatch error (13) early on, rather than an object doesn't support property or method error (438) potentially far removed from the actual problem source:

```vba
Public Sub MyMacro()
    Dim cell As Range
    Set cell = Selection '<~ type mismatch if Selection isn't a Range
End Sub
```

The macro recorder never generates a single control flow statement: no loops, no conditionals, no variables, no structure. Making a computer perform tedious tasks tediously may get the job done but misuses the object model inefficiently. The best way to tell a computer to do something 20 times is not to tell it 20 times to do one thing.

By declaring variables to hold Worksheet and Range objects being worked with, the need to Select and Activate everything touched is eliminated. Selection becomes useless for the most part. If a macro is triggered with a keyboard shortcut and works with the current selection, this is acceptable, but the entire code needn't work with Selection. Only validate what's selected and switch to early binding as early as possible using properly typed local variables.

Use Range.Select when programmatically visually selecting cells in the worksheet for the user to see that selection being made and later perhaps interact with.
