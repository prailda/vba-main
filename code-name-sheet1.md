---
id: 41E6-C7AB-54C1-4FFA-8F86-91E0-5E0C-9678
name: code-name-sheet1
title: "Code Name: Sheet1"
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
url: https://rubberduckvba.blog/2019/12/19/code-name-sheet1/
created_at: 2025-11-19T08:43:03
---
# Code Name: Sheet1

Multiple methods exist for obtaining `Worksheet` references: dereferencing from `Sheets` or `Worksheets` collections (via `Workbook.Sheets` or `Workbook.Worksheets`), working with `ActiveWorkbook` or object variables assigned from `Workbooks.Open`, activating windows by caption, or accessing `ThisWorkbook`. Each method requires consideration of workbook scope.

### ActiveWorkbook vs. ThisWorkbook

Only one `Workbook` is `ActiveWorkbook` at any given time. When all workbooks close, `ActiveWorkbook` becomes `Nothing` (add-ins must handle this). Workbook activation fires `Activate` events; previously active workbooks fire `Deactivate` events.

`ActiveWorkbook` can change during loops containing `DoEvents` statements. User interaction enabled by `DoEvents` allows unpredictable active workbook changes. `ActiveWorkbook` and `ActiveSheet` references should be captured into local variables at procedure start, then consistently used:

```vba
Public Sub DoSomething()
    Dim sheet As Worksheet
    Set sheet = ActiveSheet
    sheet.Range("A1").Value = 42
    sheet.Range("A2").Value = VBA.DateTime.Date
End Sub
```

`With` blocks can hold object references, but member calls require explicit qualification with the `.` operator:

```vba
Public Sub DoSomething()
    With ActiveSheet
        .Range("A1").Value = 42
        .Range("A2").Value = VBA.DateTime.Date
    End With
End Sub
```

Omitting the `.` operator creates implicit qualifiers. Unqualified `Range` calls implicitly refer to `ActiveSheet` outside worksheet modules, or to the worksheet module itself (`Me`) when inside worksheet modules.

`ThisWorkbook` refers to the host document containing the VBA project, regardless of add-in status. `ThisWorkbook` may or may not be `ActiveWorkbook`.

Treating `ThisWorkbook` worksheets like any other workbook's worksheets is a common error.

### Compile-Time, Run-Time

Worksheets existing in `ThisWorkbook.Worksheets` at compile-time automatically create project-scope variables named after the module's `(Name)` property. The "Name" property (user-modifiable tab caption) differs from the "(Name)" property (visible only in VBE).

By default, the first sheet's code name is `Sheet1`, matching its `Name` property. Referencing by name property:

```vba
Dim sheet As Worksheet
Set sheet = ThisWorkbook.Worksheets("Sheet1")
sheet.Range("A1").Value = 42
```

User-renamed sheets cause runtime error 9 (subscript out of range). Using the `(Name)` property with meaningful identifiers like `SummarySheet`:

```vba
SummarySheet.Range("A1").Value = 42
```

Programmatic code names resist user tampering compared to sheet tab captions.

Code names only access `ThisWorkbook` compile-time worksheets. Naming all worksheet modules and using these names eliminates collection dereferencing for compile-time sheets.

`Set sheet = Sheets("Sheet1")` represents a missed opportunity when Sheet1 exists at compile-time, or constitutes a bug when Sheet1 does not exist in `ThisWorkbook`. Rubberduck's sheet accessed using string inspection identifies this anti-pattern.
