---
id: 1C89-10A2-FE2E-4DF2-9569-4A1E-F68D-09F6
name: secure-adodb
title: Secure ADODB
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
url: https://rubberduckvba.blog/2020/04/22/secure-adodb/
created_at: 2025-11-19T08:43:12
---
# Secure ADODB

## Problem Definition

VBA projects outside Access lack database engines. Excel worksheets serve as ad-hoc databases but fail at referential integrity. ADODB enables proper database access but introduces security vulnerabilities.

Basic ADODB query:

```vba
Dim conn As ADODB.Connection
Set conn = New ADODB.Connection
conn.Open "ConnectionString"

Dim rs As ADODB.Recordset
Set rs = conn.Execute("SELECT Field1, Field2 FROM Table1")

rs.Close
conn.Close
```

Repeated queries with varying values create problems:

```vba
For i = 1 To 10
    Set rs = conn.Execute("SELECT Field1, Field2 FROM Table1 WHERE Field3 = " & i)
    rs.Close
Next
```

String concatenation (`WHERE Field3 = " & i`) forces database engine to recompute execution plans repeatedly and creates SQL injection vulnerabilities.

## Parameterized Commands

Proper implementation using `ADODB.Command`:

```vba
Const sql As String = "SELECT Field1, Field2 FROM Table1 WHERE Field3 = ?"

For i = 1 To 10
    Dim cmd As ADODB.Command
    Set cmd = New ADODB.Command
    cmd.CommandType = adCmdText
    cmd.CommandText = sql
    cmd.Parameters.Append cmd.CreateParameter(Type:=adInteger, Value:=i)

    Dim rs As ADODB.Recordset
    Set rs = cmd.Execute
    rs.Close
Next
```

Benefits:
- Database reuses cached execution plan
- Eliminates SQL injection vulnerabilities
- Handles special characters (`O'Connor`) correctly

Parameterization prevents SQL injection regardless of implementation. String concatenation breaks with valid inputs containing quotes.

## Object-Oriented Architecture

Abstraction encapsulates ADODB complexity. Key interfaces:

- `IUnitOfWork`: Encapsulates database transactions
- `IDbCommand`: Executes parameterized SQL statements
- `IDbConnection`: Manages connection lifecycle
- `IParameterProvider`: Creates ADODB parameters from variants
- `ITypeMap`: Maps VBA types to ADODB types

### Usage

```vba
Dim results As ADODB.Recordset
Set results = UnitOfWork.FromConnectionString(connString).Command.Execute(sql)
```

Single-value query:

```vba
UnitOfWork.FromConnectionString(connString).Command.GetSingleValue("SELECT Field1 FROM Table1 WHERE Id=?", 1)
```

## Implementation Details

### DbCommandBase

Provides shared functionality for `IDbCommand` implementations via composition. Key responsibilities:

- Parameter validation
- Disconnected recordset creation
- Command object creation

Parameter validation:

```vba
Public Function ValidateOrdinalArguments(ByVal sql As String, ByRef args() As Variant) As Boolean
    On Error GoTo CleanFail
    Dim expected As Long
    expected = Len(sql) - Len(Replace(sql, "?", vbNullString))

    Dim actual As Long
    On Error GoTo CleanFail
    actual = UBound(args) + (1 - LBound(args))

CleanExit:
    ValidateOrdinalArguments = (expected = actual)
    Exit Function
CleanFail:
    actual = 0
    Resume CleanExit
End Function
```

Disconnected recordset:

```vba
Private Function GetDisconnectedRecordset(ByVal cmd As ADODB.Command) As ADODB.Recordset
    Dim result As ADODB.Recordset
    Set result = New ADODB.Recordset

    result.CursorLocation = adUseClient
    result.Open Source:=cmd, CursorType:=adOpenStatic

    Set result.ActiveConnection = Nothing
    Set GetDisconnectedRecordset = result
End Function
```

### DbCommand Implementations

Two implementations exist:
- `DefaultDbCommand`: Receives `IDbConnection` via property injection
- `AutoDbCommand`: Creates own connection from connection string

Both compose with `DbCommandBase` for shared functionality.

### Abstract Factory Pattern

`IDbConnectionFactory` enables dependency injection for testing:

```vba
'@Folder("SecureADODB.DbConnection")
Option Explicit
Implements IDbConnectionFactory

Private Function IDbConnectionFactory_Create(ByVal connString As String) As IDbConnection
    Set IDbConnectionFactory_Create = DbConnection.Create(connString)
End Function
```

Test stub tracks invocations:

```vba
'@Folder("Tests.Stubs")
Option Explicit
Implements IDbConnectionFactory
Private Type TInvokeState
    CreateConnectionInvokes As Long
End Type
Private this As TInvokeState

Private Function IDbConnectionFactory_Create(ByVal connString As String) As IDbConnection
    this.CreateConnectionInvokes = this.CreateConnectionInvokes + 1
    Set IDbConnectionFactory_Create = New StubDbConnection
End Function
```

### Unit of Work Pattern

Encapsulates database transactions. Operations succeed/fail atomically:

```vba
'@Folder("SecureADODB.UnitOfWork")
'@Interface
Option Explicit

Public Sub Commit()
End Sub

Public Sub Rollback()
End Sub

Public Function Command() As IDbCommand
End Function
```

Transaction example: Transferring funds between accounts requires both UPDATE operations succeed or both roll back.

Implementation provides two factory methods:

```vba
Public Function FromConnectionString(ByVal connString As String) As IUnitOfWork
    Dim db As IDbConnection
    Set db = DbConnection.Create(connString)

    Dim provider As IParameterProvider
    Set provider = AdoParameterProvider.Create(AdoTypeMappings.Default)

    Dim baseCommand As IDbCommandBase
    Set baseCommand = DbCommandBase.Create(provider)

    Dim factory As IDbCommandFactory
    Set factory = DefaultDbCommandFactory.Create(baseCommand)

    Set FromConnectionString = UnitOfWork.Create(db, factory)
End Function
```

Transactions automatically roll back on destruction unless committed:

```vba
Private Sub Class_Terminate()
    On Error Resume Next
    If Not this.Committed Then this.Connection.RollbackTransaction
    On Error GoTo 0
End Sub
```

## Guard Clauses

The `Errors` module provides validation procedures:

```vba
'@Folder("SecureADODB")
Option Explicit
Option Private Module

Public Const SecureADODBCustomError As Long = vbObjectError Or 32

Public Sub GuardExpression(ByVal throw As Boolean, _
    Optional ByVal Source As String = "SecureADODB.Errors", _
    Optional ByVal message As String = "Invalid procedure call or argument.")
    If throw Then VBA.Information.Err.Raise SecureADODBCustomError, Source, message
End Sub

Public Sub GuardNullReference(ByVal instance As Object, _
    Optional ByVal Source As String = "SecureADODB.Errors", _
    Optional ByVal message As String = "Object reference cannot be Nothing.")
    GuardExpression instance Is Nothing, Source, message
End Sub
```

Guard clauses prevent invalid state. Unit tests verify error conditions:

```vba
'@TestMethod("Factory Guard")
Private Sub Create_ThrowsIfNotInvokedFromDefaultInstance()
    On Error GoTo TestFail

    With New AutoDbCommand
        On Error GoTo CleanFail
        Dim sut As IDbCommand
        Set sut = .Create("connection string", New StubDbConnectionFactory, New StubDbCommandBase)
        On Error GoTo 0
    End With

CleanFail:
    If Err.Number = ExpectedError Then Exit Sub
TestFail:
    Assert.Fail "Expected error was not raised."
End Sub
```

## Target Audience

This API suits:
- VB6 applications with widespread ADODB usage
- Complex data-driven VBA systems
- Learning secure parameterized query patterns
- Demonstrating OOP in Classic VB

Key concepts demonstrated:
- OOP foundations: abstraction, encapsulation, polymorphism
- SOLID principles: single responsibility, dependency inversion
- DI techniques: property injection, abstract factory
- Unit testing: testability, stubbing dependencies
- Guard clauses and input validation

Complete code: [https://github.com/rubberduck-vba/examples/tree/master/SecureADODB](https://github.com/rubberduck-vba/examples/tree/master/SecureADODB)
