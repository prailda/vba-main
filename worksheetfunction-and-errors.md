---
id: 016B-BDF4-07D3-48BF-A5AB-E634-D94B-5EC8
name: worksheetfunction-and-errors
title: WorksheetFunction and Errors
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
url: https://rubberduckvba.blog/2021/02/15/worksheetfunction-and-errors/
created_at: 2025-11-19T08:43:15
---
# WorksheetFunction and Errors

## Using Excel Worksheet Functions

Using Excel worksheet functions taps into the native calculation engine. Using Excel's MATCH function instead of writing a lookup loop makes sense when the project is hosted in Excel or references the Excel type library.

Worksheet functions may appear as:

```vba
Dim result As Variant
result = Application.WorksheetFunction.Match(...)
```

Or as:

```vba
Dim result As Variant
result = Application.Match(...)
```

Both work during testing, and might be used interchangeably, until a cryptic runtime error occurs.

The canned default message for error 1004 is "Application-defined or object-defined error." The message for a worksheet function raising this error is more confusing: "unable to get the {function name} property of the WorksheetFunction class." This templated error message mistakenly includes "property" instead of "function," but even correcting this makes no sense until understood as "the worksheet function returned a worksheet error value." If the same invocation were typed in a worksheet cell formula, Excel's error-handling would produce the same result: the cell would contain an #N/A error.

When MATCH or VLOOKUP fails in a cell, that cell's error value propagates to any caller/cell referencing it. When invoking these functions from VBA code, these errors propagate into VBA code.

Given bad arguments or a failed lookup, Application.WorksheetFunction.Match and Application.Match behave very differently. The two forms are not interchangeable.

## Early Bound: Errors are Raised

When invoking WorksheetFunction members, errors are raised as VBA runtime errors. A failed lookup can be caught with an On Error statement like any other runtime error.

```vba
  On Error GoTo LookupFailed
  Debug.Print Application.WorksheetFunction.VLookup(...)
  Exit Sub
LookupFailed:
  Debug.Print "..."
  Resume Next
```

When typing these member calls, early-bound code is indicated by IntelliSense listing that member in an inline dropdown. VLookup is a member of the object returned by the WorksheetFunction property of the Application object.

The implication is that the function is assumed to "just work." If using that function with the same parameter values in a worksheet formula results in #REF!, #VALUE!, #N/A, #NAME?, or any other Variant/Error value, then the early-bound WorksheetFunction equivalent raises runtime error 1004.

This VBA-like behavior is useful when any failure of the worksheet function needs to be treated as a runtime error, for example when the function is expected to succeed every time and failure would be a bug. Throwing an error enables early recovery.

When the outcome is unknown and a worksheet function returning an error is one possible outcome, using error handling for control flow is a design smell. Runtime errors should be used for exceptional things not expected. When a worksheet function can fail as part of normal execution, other options exist.

## Late Bound: Errors are Values

When invoking worksheet functions using late-bound member calls against an Excel.Application object, when a function fails, it returns an error code.

```vba
Dim result As Variant
result = Application.VLookup(...)
```

The Variant type means nothing until it gets a subtype at runtime. result is Variant/Empty until assignment succeeds. When it does, result might be Variant/Double if numeric. If lookup failed, instead of raising a runtime error, result will be a Variant/Error value.

### Operations Involving Variant/Error: Removing Assumptions

Because a failed late-bound WorksheetFunction returns an error value, it's easy to forget the data type might not be convertible to the declared type. The first opportunity for problems materializes if a non-error result is simply assumed by declaring a non-Variant data type for the variable assigned with the function's result:

```vba
Dim result As Long 'assumes a successful lookup...
result = Application.VLookup(...) 'runtime error 13 when lookup fails!
```

Systematically assigning these results to a Variant addresses this:

```vba
Dim result As Variant
result = Application.VLookup(...)
```

However, this only moves the type mismatch error further down:

```vba
If result > 0 Then 'runtime error 13 when result is Variant/Error!
```

The first action with a Variant should be removing assumptions about its content. The VBA.Information.IsError function returns True given a Variant/Error. This must be used to correctly remove assumptions about the result variable contents:

```vba
Dim result As Variant
result = Application.VLookup(...)
If IsError(result) Then
    'lookup failed

Else
    'lookup succeeded

End If
```

Inside the lookup failed conditional block, result is a Variant/Error value that can only be compared against another Variant/Error value. Involving result in an operation with any other runtime type will throw a type mismatch error.

Using the VBA.Conversion.CVErr function, a Long integer can be converted into a Variant/Error value. The Excel object model library includes named constants for each type of worksheet error, usable with the CVErr function to refine knowledge of result contents beyond "something went wrong":

```vba
Dim result As Variant
result = Application.VLookup(...)
If IsError(result) Then
    'lookup failed
    Select Case result
        Case CVErr(xlErrNA)
            'result is a #N/A error: value wasn't found in the lookup range

        Case CVErr(xlErrRef)
            'result is a #REF! error: is the lookup range badly defined?

        Case Else
            'result is another type of error value

    End Select

Else
    'lookup succeeded

End If
```

By systematically treating the result of a late-bound Application.{WorksheetFunction} call as a potential Variant/Error value, assumptions about success are avoided and bad results are handled without exposing the "happy path" to type mismatch errors. Standard If...Else...Then control flow statements branch execution differently depending on outcome, using standard On Error statements for exceptional situations beyond these worksheet errors already accounted for.

## Other Variant/Error Pitfalls

The IsError function isn't just useful for determining whether a late-bound WorksheetFunction call returned a usable value. The function returns True given any Variant/Error value, making it the perfect tool to identify worksheet cells containing unusable values.

```vba
Dim cell As Range
Set cell = Sheet1.Range("A1")
If cell.Value > 42 Then 'assumes cell.Value can be compared to 42!
    '...
End If
```

VBA code often assumes cells contain valid values. Whenever that assumption is broken, a type mismatch error occurs. Unless the cell value was written by the same VBA code, it's never safe to assume a worksheet cell contains expected content. Using the IsError function removes such assumptions and makes code more resilient:

```vba
Dim cell As Range
Set cell = Sheet1.Range("A1")
If Not IsError(cell.Value) Then
    If cell.Value > 42 Then
        '...
    End If
Else
    MsgBox cell.Address(External:=True) & " contains an unexpected value."
End If
```

A Variant/Error value can cause trouble in other ways. Sometimes it's an implicit conversion to String that causes the type mismatch:

```vba
Dim cell As Range
Set cell = Sheet1.Range("A1")
MsgBox cell.Value 'assumes cell.Value can be converted to a String!
```

Implicit conversions can be hard to spot. If code blows up with a type mismatch error involving a worksheet cell value or a value returned by a worksheet function, implicit conversion is where to look.
