---
id: EF6B-0078-1BD4-4A7F-A795-63E2-5C3F-6C24
name: typed-arrays-must-die
title: Typed Arrays Must Die
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
url: https://rubberduckvba.blog/2024/04/20/typed-arrays-must-die/
created_at: 2025-11-19T08:43:13
---
# Typed Arrays Must Die

## Variant for Value Types

`Variant` should be avoided when a more specific data type can be used instead for intrinsic data types (`Long`, `Date`, `String`, etc.). For object types, using `Variant` instead of a specific class interface makes calls inherently `Late-Bound`, resolvable only at runtime because the actual class/interface type is unknown at compile-time. The `VBE` won't show member/completion lists or parameter info for Variant `objects`. `Object` is a better option for explicit late binding.

## Variant for Arrays

`Variant` excels as the return type for Excel `UDF`s (`user-defined functions`). When functions succeed, they return one variant subtype; when they fail, they return a `Variant`/`Error` value to the `Worksheet`. `Variant` is optimal for `Arrays` because typed `Arrays` present numerous complications.

## Typed Array Characteristics

A "typed" array is declared with a specific element type:

```vba
Option Explicit
Private DynamicallySizedArray() As String
Private FixedSizeArray(1 To 10) As String
```

The distinction between fixed and dynamically sized arrays matters in language specifications. Syntax requires specifying `Array` bounds after the identifier name. `As String(10)` is a `Syntax Error`, not an `Array`.

Parameter declaration requires explicit `ByRef` modifier since `Arrays` can only be passed by reference:

```vba
Private Sub DoSomething(ByRef Values() As String)
End Sub
```

Declaring this parameter `ByVal` causes a `Compile-Time Error`. Since property value parameters are always passed by value (even if declared `ByRef`), typed `Arrays` are problematic with property definitions:

```vba
Public Property Let SomeValues([ByVal] Values() As String)
End Property
```

Returning a typed `Array` requires this syntax:

```vba
Public Function GetSomeValues() As String()
End Function
```

Specifying `Array` bounds or string length is illegal here. The parentheses after the identifier denotes the parameter list and must be included even when empty. The syntax is inconsistent and confusing at compile time, and runtime behavior adds further complexity.

## ReDim Complications

VBA defers much to runtime. Attempting to ReDim a With block variable or ParamArray parameter causes compile errors, but these cause runtime errors with the Preserve modifier:

- Changing array dimension count
- Changing array lower boundary
- Changing upper boundary of non-final dimensions

## Assignment Restrictions

A fixed-size array can be assigned to if the value has the same dimension count, same dimension sizes, and all values are the default type value. A resizable array can be assigned to only if it has no dimensions. This context-dependent behavior occupies mental space or causes problems the compiler cannot detect until runtime.

## Variant/Array Advantages

Variant can hold anything, including arrays. Declaring `ByVal Things As Variant` simplifies array work. A Variant/Array behaves as expected. Adding one pointer indirection layer by "hiding" arrays behind Variant enables all normal array operations plus function signatures without ambiguous parentheses placement.

```vba
Public Function GetSomeValues() As String()
End Function
```

Becomes:

```vba
Public Function GetSomeValues() As Variant
End Function
```

Behind Variant, arrays can be passed freely. No array data actually moves; pointers are moved, similar to how objects (pointers) are passed. Passing Variant by value passes a pointer copy indicating "your array is over here," exactly like object references.

Without Variant wrapping, passing arrays by value would copy the entire literal array, which VBA refuses to do, forcing arrays to be passed by reference.

Placing arrays into Variant makes them pass as references regardless of ByRef or ByVal specification, which is what VBA requires.

```vba
Private Sub DoSomething(ByVal Values As Variant)
End Sub
```

This aligns with the mental concept of passing an array to a procedure. Accepting that a pointer is passed keeps ByRef/ByVal rules simple. Assigning the array pointer to Variant has no restrictions; it "just works."

## Conclusions

Arrays are useful in VBA, but using them at their originally intended abstraction level is full of traps and caveats. Working with Variant maintains array functionality while eliminating inherent array variable restrictions. Arrays in VBA are less irritating when VBA doesn't know it's looking at one.
