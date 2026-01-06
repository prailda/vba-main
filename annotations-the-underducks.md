---
id: 4114-1AF6-E8C0-4A1A-AFF7-8217-6441-1D55
name: annotations-the-underducks
title: "@Annotations: The Underducks"
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
url: https://rubberduckvba.blog/2017/03/05/annotations-the-underducks/
created_at: 2025-11-19T08:42:59
---
# @Annotations: The Underducks

Rubberduck features implemented through annotations lack direct UI exposure, making them less discoverable despite their utility.

### @Folder

Since v2.0.12, test modules automatically appear under a "Tests" folder in the Code Explorer. VBA does not support actual folders; modules are embedded in the host document. Rubberduck simulates folder organization through annotations.

An early-bound 2.0.12 test module's declarations section demonstrates the syntax:

```vba
Option Explicit
Option Private Module
'@TestModule
'@Folder("Tests")

Private Assert As New Rubberduck.AssertClass
```

The `@Folder("Tests")` annotation creates virtual folder organization in the Code Explorer. The dot separator creates nested folder structures:

```vba
'@Folder("Tests.Functionality2")
```

Modules sharing the same root folder name are grouped together. This enables organizing large VBA projects with many classes into logical namespaces, though VBA namespace rules remain unchanged: same-name modules cannot exist in the same project regardless of folder assignment.

#### Multiple Annotations

Rubberduck uses only the first `@Folder` annotation encountered in a module; subsequent annotations are ignored. Multiple `@Folder` annotations trigger an inspection warning. Future versions will provide quick-fixes to remove extraneous annotations.

### @IgnoreModule

The `@IgnoreModule` annotation prevents code inspections from examining a specific module, reducing noise from modules that cannot be immediately fixed:

```vba
'@IgnoreModule
```

This disables all inspections for the module. To disable specific inspections, parameterize the annotation:

```vba
'@IgnoreModule UseMeaningfulName
```

Inspection names derive from internal class names (minus the "Inspection" suffix). The Rubberduck website's Inspections/List page provides a complete list. Names use PascalCase without spaces (e.g., "Use Meaningful Name" becomes `UseMeaningfulName`).

The `@Ignore` annotation operates at the individual inspection result level. The "Ignore Once" quickfix automatically inserts `@Ignore` annotations. Future versions will add automatic `@IgnoreModule` annotation insertion.
