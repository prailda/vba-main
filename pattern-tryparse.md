---
id: E134-A960-8363-4B8F-8F57-4540-809D-CE67
name: pattern-tryparse
title: "Pattern: TryParse"
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
url: https://rubberduckvba.blog/2019/05/09/pattern-tryparse/
created_at: 2025-11-19T08:43:08
---
# Pattern: TryParse

## Pattern Definition

Error handling at appropriate abstraction levels eliminates low-level error management code. The TryParse pattern, adapted from .NET, returns `Boolean` success status with result via `ByRef` parameter:

```vba
Public Function TryDoSomething(ByVal arg As String, ByRef outResult As Object) As Boolean
    'only return True and set outResult to a valid reference if successful
End Function
```

Calling code determines failure handling. Avoid `MsgBox` in Try functions; delegate responsibility to caller.

## Pattern Application

The `Try` prefix indicates `ByRef` return parameter convention. The `out` prefix (Apps Hungarian notation) signals reference-passing requirement:

```vba
Dim result As Range
If Not TryFind(Sheet1.Range("A:A"), "test", result) Then
    MsgBox "Range.Find yielded no results.", vbInformation
    Exit Sub
End If

result.Activate 'result guaranteed valid
```

## Use Cases

Handle operations that raise uncontrollable run-time errors: workbook opening, database connections, or any operation with external failure dependencies:

```vba
Public Function TryOpenConnection(ByVal connString As String, ByRef outConnection As ADODB.Connection) As Boolean
    Dim result As ADODB.Connection
    Set result = New ADODB.Connection

    On Error GoTo CleanFail
    result.Open connString

    If result.State = adOpen Then
        TryOpenConnection = True
        Set outConnection = result
    End If

CleanExit:
    Exit Function

CleanFail:
    Debug.Print "TryOpenConnection failed with error: " & Err.Description
    Set result = Nothing
End Function
```

Calling code only needs success/failure distinction:

```vba
Dim adoConnection As ADODB.Connection
If Not TryOpenConnection(connString, adoConnection) Then
    MsgBox "Could not connect to database.", vbExclamation
    Exit Function
End If

'proceed with open connection
```

## Flow Control Benefits

Use `Exit Sub`/`Exit Function` to terminate failed procedures early, eliminating nesting. Successful continuation executes without redundant `Else` blocks with confidence in valid state.

The .NET convention of paired `TryDoSomething`/`DoSomething` methods (error-throwing variant) applies primarily to framework libraries. YAGNI principle suggests omitting error-throwing variants for application code.

## Anti-Patterns

Avoid `TryDoSomethingThatCouldNeverRaiseAnError` methods. Reserve `Try` prefix for error-handling scenarios. Generally pass parameters `ByVal`; return single values via function return value.

Multiple `ByRef` output parameters indicate excessive responsibility. Extract related outputs into cohesive class. The `GridCoord` class demonstrates this: passing `X` and `Y` as single object enables equality comparison, adjacency evaluation, and string representation, functionality impossible with separate `Long` values.
