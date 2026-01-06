---
id: 8DD5-C029-80A8-4B83-85D3-3222-026B-645C
name: parentheses
title: Parentheses
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
url: https://rubberduckvba.blog/2024/10/16/parentheses/
created_at: 2025-11-19T08:43:08
---
# Parentheses

Parentheses confusion stems from missing key language mechanics.

Parentheses serve multiple purposes, sometimes creating ambiguity.

### Signatures

Procedure declarations include parentheses even without parameters. Parentheses delimit parameters lists, which may be empty.

### Expressions

VBA grammar defines operations: `And`, `Or`, `Not`, `XOr` logical operators, arithmetic operators (+, -, /, \, *, ^), and parenthesized expressions. Parenthesized expressions are defined as `LPAREN expression RPAREN`—left parenthesis, any expression (including nested parenthesized expressions), right parenthesis.

When VBA interprets parentheses as nothing more specific than parenthesized expressions, they mean: an expression to be evaluated. This distinction is crucial.

### Subscripts

VBA calls indexes subscripts (as in error 9 "subscript out of bounds"). Accessing n-th item in single-dimension array `Things` uses `Things(n)`—a subscript expression.

Grammar rules alone cannot determine whether code represents subscript expressions because another expression type matches.

### Member Calls

Member calls involve implicit `Call` keywords. They are full statements legally standing alone on code lines.

`Sub` and `Function` procedure names should begin with verbs. `Thing` function calls with singular arguments are identical to `Thing` array retrievals at parameterized indexes/subscripts. `Call` keyword resolves this ambiguity, albeit noisily.

Member calls require parentheses when:
- Having required parameters
- Being `Property Get` or `Function` procedures
- Doing anything with returned values

YES answers to all three require parentheses delimiting arguments lists. VBE removes spaces between parentheses and invoked member names.

### When things go wrong

Ignoring VBE's stubborn space insertion between procedure names and intended arguments lists causes problems:

```vba
MsgBox ("Hello")
```

This appears to call `MsgBox` library function with single string argument.

Actually written: parenthesized expression VBA evaluates before passing evaluated results to functions. This compiles and runs fine.

- Does it have required parameters? Yes!
- Is it Property Get or Function procedure? Yes, a function returning `VbMsgBoxResult`.
- Are you doing anything with returned value? No, just showing messages without caring about dismissal.

Then parentheses are unwanted. Leaving them and appending additional `Caption` arguments:

```vba
MsgBox ("Hello", "Title goes here")
```

VBA throws compile errors. Parenthesized expressions grammatically reject commas. Commas would work as `&` string concatenation operators, but parentheses remain misleading with only single arguments, no legal way to pass second arguments.

Unless dropping parentheses or capturing results:

```vba
MsgBox "Hello", "Title goes here"

Result = MsgBox("Hello", "Title goes here")
```

Spaces are removed when capturing results. VBE indicates understanding comma-separated argument lists as arguments lists rather than expressions to evaluate.

This compiles and runs, producing expected outcomes.

### ByRef Bypass

Passing parenthesized expressions passes expression results—not parenthesized local variables. Passing to procedures receiving `ByRef` parameters may inadvertently break intended behavior:

```vba
Sub Increment(ByRef Value As Long)
    Value = Value + 42
    Debug.Print Value
End Sub

Sub Test()
    Increment 10 'prints 52
    Dim A As Long
    A = 10
    Increment A 'prints 52
    Debug.Print A 'prints 52
    Dim B As Long
    B = 10
    Increment (B) 'prints 52
    Debug.Print B 'prints 10. Expected?
End Sub
```

Passing literal expressions passes values to procedures.

Passing variables: procedures receive pointers to variables (by reference); callers "see" changes. `ByRef` is implicit default; this may or may not be intentional.

Passing parenthesized expressions—even evaluating only local variables—passes results by reference, but nothing on caller side holds references. Code behaves as if passing `ByVal` arguments to `ByRef` parameters.

### Objects

Parenthesizing string or number literal values changes semantics in subtle ways usually not mattering until desiring coding style consistency.

Object reference parenthesization is different due to let-coercion: objects coerce into values by invoking object default members recursively until retrieving non-object values or encountering objects without default members. Then runtime errors occur. Exact errors depend on circumstances.

Invoking procedures accepting `Range` parameters with parenthesized expressions may pass cell values or 2D value arrays instead of `Range` objects—because `Range.[_Default]` (hidden default member) returns these. Procedures expecting `Range` objects cannot invoke due to type mismatch at call sites.

```vba
Sub DoSomething(ByVal Target As Range)
End Sub

DoSomething (ActiveSheet.Range("A1")) 'type mismatch
```

Objects without default members cannot be let-coerced. VBA raises error 438 (object doesn't support this property or method)—cryptic without understanding implicit default member calls when members don't exist.

Let-coercion can inadvertently occur against null references (`Nothing`). Passing `ActiveSheet` to procedures when all workbooks are closed and no worksheets are active: normal `ActiveSheet` reference passes allow procedures to receive `Nothing` and handle gracefully. Parentheses surrounding references cause implicit default member calls failing with error 91; procedures never invoke.

Rule of thumb: avoid implicit coercion in code, thus avoiding let-coercion and never surrounding object arguments with parentheses.
