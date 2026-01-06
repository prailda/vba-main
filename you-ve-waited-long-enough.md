---
id: E686-92DB-305B-4E83-9C4D-64AB-BDDF-68E7
name: you-ve-waited-long-enough
title: You've waited long enough.
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
url: https://rubberduckvba.blog/2015/05/03/youve-waited-long-enough/
created_at: 2025-11-19T08:43:16
---
# You've waited long enough

## Pre-Release Status

Correctly resolving identifier references proved significantly more complicated than anticipated. VBA complicates this through with blocks and user-defined-type fields.

The release is tagged as "pre-release" because resolving identifier references in VBA is complex, and the implementation has issues requiring further work. Most normal use cases are covered.

This code produces a StackOverflowException:

**Class1**

```vba
Public Function Foo() As Class2
    Set Foo = New Class2
End Function
```

**Class2**

```vba
Public Sub Foo()
End Sub
```

**ThisWorkbook**

```vba
Public Sub DoSomething()
    Dim Foo As New Class1
    With Foo.Foo
    End With
End Sub
```

This compiles and VBA resolves it, but it's fiendish and ambiguous. Nobody in their right mind would write this, but it's legal and causes failures. Hair-pulling edge cases exist that didn't cooperate.

Finding all references to "foobar" works well here:

```vba
Public Sub DoSomething()
    Dim foobar As New Class1
    With foobar
        With.Foo.Bar
        End With
    End With
End Sub
```

Finding all references to "Foo" in the below code won't blow up, but the ".Foo" in the 2nd with block resolves as a reference to the local variable "Foo":

```vba
Public Sub DoSomething()
    Dim Foo As New Class1
    With Foo
        With.Foo.Bar
        End With
    End With
End Sub
```

Other issues remain.

## Known Issues

A non-exhaustive list of relatively minor known issues are postponed to 1.31 or future releases.

### Cross-Project References

Rubberduck doesn't yet handle cross-project references. All opened VBA projects are parsed and navigatable as "silos" without considering project references. If project A references project B, and project A contains the only usage of a procedure defined in project B, that procedure will trigger a code inspection saying the procedure is never used. "Find all references" and "rename" will miss it.

### Self-Referencing Parameters

"Find all references" has been observed listing the declaration of a parameter in its list of references. Not intended but may never be encountered.

### Selection Glitches From Code Inspection Results

The cause is known: the selection length is that of the last word/token in the parser context associated with the inspection result. This is partially fixed but requires additional work.

### Performance

Code inspections were meant to get faster but got more accurate instead. This needs tuning. Inspections can be sped up by turning off the most expensive ones, though these are often the most useful.

### Function Return Value Not Assigned

Instances exist of object-typed property getters firing up inspection results when they shouldn't. This behavior hasn't been reproduced in smaller projects. This inspection is important because a function or property getter that's not assigned will not return anything, likely indicating a bug.

### Parameter Can Be Passed By Value

This inspection indicates that a ByRef parameter is not assigned a value and could safely be passed ByVal. However, if such a parameter is passed to another procedure as a ByRef parameter, Rubberduck should assume the parameter is assigned. This bit is not yet implemented. Take this inspection result with caution.

This inspection will not fire if the parameter isn't a primitive type, for performance reasons. If performance is critical, passing parameters by reference may yield better results.
