---
id: 4C9D-F94F-9DD0-41BB-965D-9F68-52D6-0B4B
name: late-binding
title: Late Binding
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
url: https://rubberduckvba.blog/2019/04/28/late-binding/
created_at: 2025-11-19T08:43:06
---
# Late Binding

VBE sometimes provides object member information (members, parameterization, return types) and sometimes does not. Late binding explains this behavior.

VBA developers can benefit from writing code adhering to VB.NET `Option Strict` rules regarding late binding, virtually eliminating error 438 possibilities.

Coding against dynamic APIs exempts from these rules. For everything else, it is mandatory.

#### What is Late Binding?

Survey indicates 67% of VBA developers associate "late binding" with `CreateObject`. While `CreateObject` is the only way to create instances without compile-time references, it primarily performs registry lookups. The function accepts `ProgID` or `GUID` corresponding to registry-existing classes. If `ProgID` does not exist in registry, errors are raised; no objects are created. While useful for providing alternative implementations (handling errors returning compatible objects), this is rarely utilized. Misconceptions exist that `CreateObject` magically creates objects from nonexistent libraries—a gross falsehood.

Consider these lines:

```vba
Dim app As Excel.Application
Set app = CreateObject("Excel.Application")
```

Assuming compilation, no late binding occurs. `CreateObject` complicates `Set app = New Excel.Application` by locating registry `ProgID`, loading libraries, finding types, creating instances, and returning objects.

Late binding occurs when member calls target `Object` interfaces.

```vba
Dim app As Object
Set app = CreateObject("Excel.Application")
```

Referencing `Excel` type library enables compile-time `Excel.Application` type binding. However, early binding is version-specific. Code against Excel 2016 type library may fail compilation or execution for Excel 2010 users (even when avoiding newer APIs). Late binding solves this: code works against whatever library version exists on user machines (still fails for Excel 2003 lacking `Worksheet.ListObjects`). The downside: no `Worksheet` or `Workbook` declarations since compilers do not recognize unreferenced library classes or `xlXYZ` global constants.

Problems arise using late binding for essentially guaranteed libraries on modern Windows machines (like `Scripting`). If code cannot work without these libraries, late-binding them solves no problems. Late-bound code compiles with typos and glaring misuses; no IntelliSense or parameter QuickInfo. This easily triggers error 438 (member not found):

```vba
Dim d As Object
Set d = CreateObject("Scripting.Dictionary")
d.Add "value", "key"
If d.ContainsKey("key") Then
End If
```

#### It's not about project references

Late binding is not about referenced libraries or `CreateObject` types. Not referencing libraries forces late binding everything, but late binding occurs even using only host application object models and VBA standard libraries. Every time anything returns `Object` and member calls proceed without casting to compile-time known interfaces, late-bound member calls resolve only at runtime.

Type these examples; feel the difference:

```vba
Dim lateBound As Object
Set lateBound = Application.Worksheets("Sheet1")
latebound.Range("A1").Value = 42

Dim earlyBound As Worksheet
Set earlyBound = Application.Worksheets("Sheet1")
earlyBound.Range("A1").Value = 42
```

`Worksheets` yields `Object` that might be `Worksheet` references or `Sheets` collections (depending on parameterization with strings/sheet names versus arrays). Excel object model has dozens of methods returning `Object`. Automating Excel from VB.NET with `Option Strict` forbids late-bound member calls outright.

VBA is more permissive. VBA developers must understand what happens, why, and how to make things more robust, failing at compile-time whenever possible. Systematically declaring explicit types and avoiding `Object` member calls accomplishes this and:
- Prepares for less permissive compilers; treating late-bound calls as errors eases .NET transitions
- Improves object model understanding: what types methods return, what to research when problems occur
- Adheres to modern programming standards

Late binding is not inherently evil; it is a powerful tool. Using it when early-bound alternatives exist abuses the language feature.

When typing member calls without VBE member suggestions, consider introducing local variables declared with explicit types, maintaining compile-time validation. Rubberduck will "see" more code, yielding fewer inspection false positives and false negatives.
