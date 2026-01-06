---
id: EF3A-9FC3-3F4B-422A-9F57-EAA2-81D7-8D34
name: document-modules
title: Document Modules
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
url: https://rubberduckvba.blog/2019/12/08/document-modules/
created_at: 2025-11-19T08:43:03
---
# Document Modules

Document modules (`ThisWorkbook`, `Sheet1`) serve as the gateway to VBA development. Initial VBA exploration in the Visual Basic Editor begins with visualizing VBA projects in the Project Explorer and encountering these document modules.

In the VBIDE Extensibility object model, modules are accessed via `VBComponents` property of `VBProject` objects. The `VBComponent.Type` property has value `vbext_ComponentType.vbext_ct_Document` for both `ThisWorkbook` and `Sheet1` modules, versus `vbext_ct_StdModule` for standard modules. Document modules, while being class modules, require special compiler treatment.

### Document?

VBA is host-agnostic, operating identically across Excel, PowerPoint, AutoCAD, Sage, Corel Draw, and 200+ licensed hosts. VBA lacks intrinsic knowledge of `Excel.Worksheet`; only the `Excel` library contains this knowledge. When VBA projects are hosted in Excel, the `Excel` type library is automatically added and locked (non-removable) to projects. Document modules are special modules that the VBIDE treats as VBA project parts but cannot add or remove directly. Adding or removing `Worksheet` modules requires adding or removing worksheets from the host Excel workbook.

Beyond indirect addition/removal requirements, document modules have unique characteristics.

Host applications determine VBA project contents, including document representation modules and circumstances for adding/removing modules like `Worksheet` or `Chart`.

Document modules cannot be instantiated or destroyed, lacking `Initialize` or `Terminate` event handlers. However, host applications fire convenient events at various times, exposed as programmatic extensibility points. `ThisWorkbook` includes events like `Workbook.Open` and `Workbook.NewSheet`. `Worksheet` modules include worksheet-specific events like `Worksheet.SelectionChange` or `Worksheet.Change`, enabling custom code "hooks" for specific host document occurrences.

### ThisWorkbook

VBA projects are hosted inside Excel documents. The host document is referenced in VBA projects with an identifier, defaulted to `ThisWorkbook` (renaming is not recommended).

The Excel workbook containing the current VBA project is `ThisWorkbook`. Code-behind in that module extends a `Workbook` object. Typing `Me.` displays IntelliSense/autocomplete lists with all public members found on any `Workbook` object, plus any explicitly or implicitly `Public` members. Document modules literally inherit members from other classes (inheritance), something VBA user code cannot do. Visual Basic for Applications internally supports class inheritance. Similar inheritance occurs with `UserForm` code: `UserForm1` class inherits members from any other `UserForm`. Every `Sheet1` inherits members from every other `Worksheet`.

Procedures written in document modules should relate closely to that particular document. Host-agnostic logic cannot add/remove these modules, necessitating minimal code in them. This simplifies VBA project source control, as code resides in modules that VBE add-ins can properly import and synchronize with file systems.

#### ActiveWorkbook

`ActiveWorkbook` refers to the currently active workbook in the Excel `Application` instance, which may or may not be `ThisWorkbook`/the host document. Confusing the two and writing code assuming equivalence is common. The macro recorder and many documentation examples/Stack Overflow answers make this assumption. Reliable code minimizes assumptions. Built-in assumptions eventually break, producing intermittent error 1004 that occurs during debugging or user operations but disappears upon observation.

### Accessing Worksheets

Frequent worksheet dereferencing is unnecessary. When necessary, correct implementation and reasoning are important. First determination: does the sheet exist in `ThisWorkbook` at compile-time (present in the host document with a document module in the VBA project).

If the answer is affirmative (e.g., `Sheet3` exists), the `Worksheet` object already exists without requiring `Sheets` or `Worksheets` collection dereferencing.

```vba
Dim sheet As Worksheet
Set sheet = ThisWorkbook.Worksheets("Sheet1") '<~ bad if Sheet1 exists at compile-time!

Set sheet = Sheet1 '<~ bad: redundant variable obfuscates target
sheet.Range("A1").Value = 42 '<~ bad if sheet is local variable, good if parameter

Sheet1.Range("A1").Value = 42 '<~ most reliable worksheet reference
```

The `Sheet1` identifier originates from the `(Name)` property of the `Sheet1` document module under `ThisWorkbook`. Setting this property to valid, meaningful names creates user-proof references to `ConfigurationSheet`, `SummarySheet`, and `DataSheet`. User-renamed `DataSheet` to "Data (OLD)" breaks this code:

```vba
ThisWorkbook.Worksheets("Data").Range("A1").Value = 42
```

This code survives user-induced sheet-name tampering:

```vba
DataSheet.Range("A1").Value = 42
```

#### Sheets vs Worksheets

Neither `.Sheets()` nor `.Worksheets()` are language-level keywords; they are member calls. Unqualified references in `ThisWorkbook` modules refer to `Me.Worksheets` (`ThisWorkbook.Worksheets`); elsewhere they implicitly refer to `ActiveWorkbook.Worksheets`. Properly qualifying member calls is important. `Worksheets` is a `Workbook` object member, requiring explicit `Workbook` object qualification.

`Sheets` and `Worksheets` both return `Excel.Sheets` collection objects whose default `Item` member returns `Object`. Both accept sheet name strings or sheet index integers. Both raise runtime error 9 ("subscript out of range") with arguments referring to non-existent sheets in qualifying workbook objects. Both return `Sheets` collection objects given sheet name arrays. `Item` returning `Object` rather than `Worksheet` accommodates this, and accounts for `Chart` sheets versus `Worksheet`.

Use `Worksheets` collection for retrieving `Worksheet` items. `Sheets` collection contains all sheets regardless of type; use it for retrieving `Chart` objects for chart sheets. Both are equivalent, but `Worksheets` is semantically more specific and preferred for common `Worksheet`-dereferencing scenarios.

### Dereferencing Workbooks

Working exclusively with `ThisWorkbook` eliminates these concerns. Opening other workbooks and manipulating sheets in those workbooks requires managing what workbook is currently `ActiveWorkbook` through `Activate` calls and repeated `Workbooks("foo.xlsm").Activate` invocations, or properly maintaining references to handled objects.

`Application.Workbooks.Open` returns a `Workbook` object reference upon successful file opening.

`Workbooks.Open` is side-effecting: successfully opening workbooks makes them the new `ActiveWorkbook`, affecting global state.

Working off `ActiveWorkbook` or unqualified `Worksheets(...)` member calls creates code heavily reliant on function side effects and global state generally.

Capture function return values and store object references in local variables:

```vba
Dim book As Workbook
Set book = Application.Workbooks.Open(path) '<~ global-scope side effects irrelevant

Dim dataSheet As Worksheet
Set dataSheet = book.Worksheets("DATA")
```

VBA code opening workbooks has no reason to lack `Workbook` references to those objects.

#### ActiveWorkbook Uses

As arguments to procedures taking `Workbook` parameters agnostic about workbook identity, or when assigning `Workbook` object variables (presumably `WithEvents` module-scope private variables in class modules) to whatever workbook is currently active. With few specific exceptions, that's all.

`ActiveWorkbook.Whatever` is not normally desirable code.

### Chaining Calls

Maintaining VBA compiler awareness of all operations is optimal. Early-bound code enables complete Rubberduck understanding. Implicit late binding is too easily introduced, primarily through chained member calls:

```vba
book.Worksheets("Sheet1").Range("A1").Value = 42 '<~ late bound at.Range
```

Everything after `Worksheets("Sheet1")` is late-bound because `Excel.Sheets.Item` returns `Object`. Member calls against `Object` are only resolvable at run-time.

Introducing `Worksheet` variables to collect `Object` casts it to usable compile-time interfaces (`Worksheet`), enabling VBA compiler validation of `.Range` member calls:

```vba
Dim sheet As Worksheet
Set sheet = book.Worksheets("Sheet1")
sheet.Range("A1").Value = 42 '<~ all early bound
```

Chained early-bound member calls are acceptable. The compiler validates `Range.Value` member calls because `Excel.Worksheet.Range` property getters return `Range` references. If returning `Object`, declaring `Range` local variables to capture `Excel.Range` objects would be required:

```vba
Dim sheet As Worksheet
Set sheet = book.Worksheets("Sheet1") '<~ good: casts Object into Worksheet

Dim cell As Range
Set cell = sheet.Range("A1") '<~ redundant: sheet.Range("A1") returns early-bound Range
cell.Value = 42 '<~ early-bound, but sheet.Range("A1").Value = 42 also early-bound
```

Avoid declaring extraneous variables, but use local variables to turn `Object` into compile-time types providing IntelliSense, autocompletion, and parameter quick-info, avoiding runtime error 438 for typos `Option Explicit` cannot prevent. Using the compiler to validate everything validatable is sound practice.

Repeatedly invoking members off early-bound objects benefits from local variables reducing dereferencing and repetition:

```vba
sheet.Range("A1").Value = "Rubberduck"
sheet.Range("A1").Font.Bold = True
sheet.Range("A1").Font.Size = 72
sheet.Range("A1").Font.Name = "Showcard Gothic"
```

Introducing local variables reduces cognitive load and eliminates repeated identical `Range` object pointer dereferencing:

```vba
Dim cell As Range
Set cell = sheet.Range("A1")

cell.Value = "Rubberduck"
cell.Font.Bold = True
cell.Font.Size = 72
cell.Font.Name = "Showcard Gothic"
```

Nested `With` blocks can hold all object references involved, reducing dereferencing to strict minimums (`.Font` invoked once, reference witheld), but readability effects are debatable:

```vba
With sheet.Range("A1")
    .Value = "Rubberduck"
    With .Font
        .Bold = True
        .Size = 72
        .Name = "Showcard Gothic"
    End With
End With
```

Avoiding nested `With` blocks is a fair compromise:

```vba
Dim cell As Range
Set cell = sheet.Range("A1")

cell.Value = "Rubberduck"
With cell.Font
    .Bold = True
    .Size = 72
    .Name = "Showcard Gothic"
End With
```

This is subjective and applies to all VBA code (not just Excel object model code), but any approach surpasses cleaned-up macro-recorder code:

```vba
    Range("A1").Select
    ActiveCell.Value = "Rubberduck"
    With Selection.Font
        .Name = "Showcard Gothic"
        .Bold = True
        .Size = 72
    End With
```

Note implicit `ActiveSheet` reference with implicitly-qualified `Range` member call, `Range.Select` use followed by `ActiveCell` use, and `With` block holding late-bound `Range.Font` reference through `Selection` object. The compiler validates nothing inside that `With` block.

Macro recorder code does not declare local variables; instead, it `Select`s things and works late-bound against `Selection`. This makes it a poor teacher. While useful for showing members to use, it operates without leveraging compile-time checks and teaches `Activate`-ing sheets so unqualified `Range` and `Cells` member calls work off correct sheets. Proper worksheet dereferencing into local variables eliminates `Select` and `Activate` needs.
