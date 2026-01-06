---
id: 234A-6FB7-1182-48BA-9F07-E0F3-4AAC-14B0
name: on-error-resume-next
title: On Error Resume Next
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
url: https://rubberduckvba.blog/2019/05/22/on-error-resume-next/
created_at: 2025-11-19T08:43:07
---
# On Error Resume Next

`On Error Resume Next` is sometimes the appropriate tool. Consider a `ListObject` property returning `Table1` from `Sheet1`:

```vba
'@Description("Gets the 'Table1' ListObject from this sheet.")
Public Property Get Table1() As ListObject
  Set Table1 = Me.ListObjects("Table1")
End Property
```

When `Table1` is renamed in Excel, this property raises error 9 because the collection no longer contains `"Table1"`. Throwing errors from `Property Get` procedures violates property design best practices.

Using `On Error Resume Next`:

```vba
'@Description("Gets the 'Table1' ListObject from this sheet, or 'Nothing' if not found.")
Public Property Get Table1() As ListObject
  On Error Resume Next
    Set Table1 = Me.ListObjects("Table1")
  On Error GoTo 0
End Property
```

Error handling is explicitly restored with `On Error GoTo 0`. The property returns `Nothing`, deferring invalid table handling to the caller:

```vba
Dim table As ListObject
Set table = Sheet1.Table1
If table Is Nothing Then Exit Sub
```

This encourages capturing return values into local variables, leaving caching concerns to calling code, avoiding awkward situations with cached references:

```vba
'@Description("Gets the 'Table1' ListObject from this sheet.")
Public Property Get Table1() As ListObject
  Static cache As ListObject
  If cache Is Nothing Then
    Set cache = Me.ListObjects("Table1")
  End If
  Set Table1 = cache
End Property

Debug.Print Me.Table1.Name
Me.ListObjects(1).Delete
Debug.Print Me.Table1.Name ' error 424 "object required"
```

The initial call sets `cache`. Subsequent calls return the cached reference. After deleting the table, `cache` is not `Nothing` but points to a deleted object—a zombified pointer persisting until an `End` instruction terminates execution. Cache invalidation is among programming's hardest problems.

#### On Error Resume Next + Conditionals = Trouble

Generously suppressing error handling enables catastrophic bugs:

```vba
Public Sub AntiExample()
  On Error Resume Next
  Sheet1.Range("A1").Value = CVErr(xlErrNA)
  If Sheet1.Range("A1").Value = 42 Then
    MsgBox Err.Description, vbCritical
    Exit Sub
  Else
    MsgBox Err.Description, vbExclamation
    Exit Sub
  End If
  Exit Sub
Rubberduck:
  MsgBox Err.Description, vbInformation
End Sub
```

`Resume Next` is dangerous if used incorrectly. Conditionals could contain critical code. When in doubt, use `On Error GoTo Rubberduck`. If using `Resume Next`, pair it with `On Error GoTo 0` in most scenarios. Rubberduck inspection warns when this pairing is absent.

`On Error Resume Next` should fence single potentially problematic statements. This is easier when procedures are responsible for few things. Multiple potential errors in one scope indicate abstraction level should increase, moving code to smaller procedures handling fewer concerns.

Pragmatically, `On Error Resume Next` does not strictly require pairing with `On Error GoTo 0`: execution state is procedure-local, and with `Resume Next`, execution state is never in error after procedure exit. Explicit specification resembles explicit `Public` modifiers or `ByRef` specifiers—making implicit defaults explicit. Cleaner to exit procedures with `Err.Number` at `0`, consistent with execution/error state.

When `On Error Resume Next` appears at procedure tops, comment it out and run the code. Observe silently suppressed errors and code executing in uncertain error states. Narrow potential errors to specific statements, isolate them, reduce code allowed to run in error state to bare minimum. Pull dangerous statements into dedicated functions. Determine if error handling is avoidable.

Error in this code:

```vba
If Sheet1.Range("A1").Value = 42 Then
```

Avoids by verifying value compatibility before comparison:

```vba
Dim cellValue As Variant
cellValue = Sheet1.Range("A1").Value

If IsNumeric(cellValue) Then
  If cellValue = 42 Then
  End If
ElseIf Not IsError(cellValue) Then
Else
End If
```

Every situation differs. Reading `Recordset` with missing fields warrants raising errors, but cleanup must occur before scope exit. If receiving opened connections as parameters, closing is not the procedure's responsibility—the creator assumes connections remain open upon return.

The golden rule: code creating objects (or invoking factory methods) should destroy those objects.
