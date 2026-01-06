---
id: 52AB-BA59-BE7D-48B1-A358-4F9E-EFAC-89DA
name: rubberduck-annotations
title: Rubberduck Annotations
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
url: https://rubberduckvba.blog/2019/12/14/rubberduck-annotations/
created_at: 2025-11-19T08:43:11
---
# Rubberduck Annotations

## Overview

Annotations are special comments that Rubberduck's parser processes as syntax elements:

```vba
'@Folder("MyProject.Abstract")
'@ModuleDescription("An interface that describes an object responsible for something.")
'@Interface
'@Exposed

'@Description("Does something")
Public Sub DoSomething()
End Sub
```

## Syntax

Annotations follow procedure call syntax. String arguments require double quotes:

```vba
'@AnnotationName arg1, arg2, "string argument"
'@AnnotationName(arg1, arg2)
'@AnnotationName("string argument")
```

Parentheses are optional. Use instruction separator `:` to add comments:

```vba
'@Folder "Some.Sub.Folder" @ModuleDescription "Some description": additional comment
```

The `IllegalAnnotation` inspection flags unsupported annotations. Disable via severity level `DoNotShow`.

Annotations are module-level or member-level. Module annotations appear in declarations section; member annotations precede procedure declarations.

## Module Annotations

Module annotations apply to entire modules and must appear in the declarations section.

### @Folder

Organizes modules by functionality in Code Explorer. Uses dot notation for hierarchy:

```vba
'@Folder("Root.Parent.Child")
Option Explicit
```

Use `PascalCase` naming for forward compatibility with file system export. The `ModuleWithoutFolder` inspection warns of missing annotations.

### @IgnoreModule

Disables specific inspections module-wide. Accepts inspection names without `Inspection` suffix:

```vba
'@IgnoreModule ProcedureNotUsed, ParameterNotUsed
'@IgnoreModule ProcedureNotUsed: Public macros attached to shapes on Sheet1
```

Without arguments, disables all inspections in the module.

### @TestModule

Marks standard modules for unit test discovery. No parameters.

### @ModuleDescription

Controls the hidden `VB_Description` attribute for module docstrings:

```vba
'@ModuleDescription("Description text")
```

Illegal in document modules where attributes cannot be modified.

### @PredeclaredId

Controls the hidden `VB_PredeclaredId` attribute, enabling class default instances. Enables factory methods in the same class:

```vba
Dim something As Class1
Set something = Class1.Create("test", 42)
```

### @Exposed

Documents non-default class instancing property values. Makes classes accessible from referencing projects.

### @Interface

Marks abstract interface modules. Code Explorer displays dedicated icon. The `ImplementedInterfaceMember` inspection flags concrete implementations in these modules.

### @NoIndent

Prevents Smart Indenter from processing the module, preserving hidden attributes.

## Member Annotations

Member annotations apply to procedures and must immediately precede declarations:

```vba
'@DefaultMember
'@Description("Gets the item at the specified index")
Public Property Get Item(ByVal index As Long) As Object
End Property
```

### @Description

Controls the hidden `VB_Description` attribute for member docstrings. Content appears in Object Browser and Rubberduck toolbar.

### @Ignore

Disables specific inspections for annotated procedure. Works identically to `@IgnoreModule`.

### @DefaultMember

Marks the class default member. Only one member per class can be default. Useful for indexed `Item` properties in custom collections.

### @Enumerator

Identifies `For Each` enumeration members requiring `IUnknown` return type:

```vba
'@Enumerator
Public Property Get NewEnum() As IUnknown
    Set NewEnum = encapsulatedCollection.[_NewEnum]
End Property
```

### @ExcelHotkey

Assigns keyboard shortcuts in Excel-hosted projects:

```vba
'@ExcelHotkey "D": Ctrl+Shift+D
Public Sub DoSomething()
End Sub

'@ExcelHotkey "d": Ctrl+D
Public Sub DoSomethingElse()
End Sub
```

Uppercase letters include Shift modifier.

### @Obsolete

Marks deprecated procedures. Inspection flags all uses:

```vba
'@Obsolete("Use DoSomethingElse instead.")
Public Sub DoSomething()
End Sub
```

## Test Method Annotations

### @TestMethod

Identifies unit test methods. Accepts optional category string:

```vba
'@TestMethod("Some Category")
Private Sub TestMethod1()
End Sub
```

### @TestInitialize

Marks procedures invoked before each test in the module.

### @TestCleanup

Marks procedures invoked after each test in the module.

### @ModuleInitialize

Marks procedures invoked once before module tests begin.

### @ModuleCleanup

Marks procedures invoked once after all module tests complete.
