---
id: D839-D902-55B8-4BA1-8874-F2FD-49B8-E5D7
name: abstracting-worksheets
title: Abstracting Worksheets
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
url: https://rubberduckvba.blog/2017/12/08/there-is-no-worksheet/
created_at: 2025-11-19T08:42:59
---
# Abstracting Worksheets

VBA projects embedded in Excel workbooks include global-scope objects like `Sheet1` (an `Excel.Worksheet` instance) and `ThisWorkbook` (an `Excel.Workbook` instance). These objects can be accessed from anywhere in the code, but unrestricted access couples business logic directly to the host application's object model.

Abstracting away the host application's object model enables isolating logic from worksheet boilerplate, producing code patterns applicable to object-oriented languages generally.

## Abstracting Worksheets

Worksheets contain data. Whether data originates from databases or worksheets, abstraction patterns apply equally. Treating worksheets as data sources enables implementing repository patterns and other abstraction techniques.

Direct worksheet interface implementation causes issues. The alternative: wrap worksheets in proxy classes that implement required interfaces. Components requiring worksheet access use interfaces like `IWorkbookData.FooSheet`, where `FooSheet` returns an `IFooSheet`-exposed `FooSheetProxy` instance. Only `FooSheetProxy` directly accesses the `FooSheet` document module.

Example: An order form workbook distributed to sales representatives returns filled with customer order details. A macro imports this data into an ERP system. Hard-coding cell references (customer account in O8, order date in J6, delivery/cancel dates in J8/J10, line items in rows 33-73) works until requirements change: missing account numbers, shifted columns, new categories, modified size scales.

Script-like procedures handling everything from start to finish become unmaintainable as complexity and conditions accumulate.

### Name Things

Named ranges provide the first abstraction layer. Naming ranges like `Header_AccountNumber`, `Header_OrderDate`, `Header_DeliveryDate`, `Header_CancelDate`, `Details_DetailArea`, and `Details_SizedUnits` decouples code from hard-coded cell references. Layout changes require updating named ranges rather than code.

However, monolithic procedures resist unit testing. Automated tests against real worksheets fire events and perform calculations but do not constitute true unit tests. Higher abstraction levels are required.

The Order Form worksheet code-behind remains minimal:

```vba
'@Folder("OrderForm.OrderInfo")
Option Explicit
```

A proxy class implements an interface exposing required functionality:

```vba
'@Folder("OrderForm.OrderInfo")
Option Explicit

Public Property Get AccountNumber() As String
End Property

Public Property Get OrderNumber() As String
End Property

Public Function CreateOrderHeaderEntity() As ISageEntity
End Function

Public Function CreateOrderDetailEntities() As VBA.Collection
End Function

Public Sub Lockdown(Optional ByVal locked As Boolean = True)
End Sub
```

The proxy class implements this interface:

```vba
Private Property Get IOrderSheet_AccountNumber() As String
    Dim value As Variant
    value = OrderSheet.Range("Header_Account").value
    If Not IsError(value) Then IOrderSheet_AccountNumber = value
End Property
```

The `CreateOrderHeaderEntity` method creates objects consumed by ERP import macros using named ranges defined on `OrderSheet`. Macros depend on `IOrderSheet` instead of direct `OrderSheet` references, enabling test proxy implementations that do not require actual worksheets. This pattern supports writing unit tests independent of worksheets while automatically testing complete functionality.

A recent order form project contains 86 class modules, 3 standard modules, 11 user forms, and 25 worksheets (zero worksheet code-behind procedures, excluding tests). Using this pattern with MVP architecture produces clear, simple code. Most macros follow this structure:

```vba
Public Sub AddCustomerAccount()
    Dim proxy As IWorkbookData
    Set proxy = New WorkbookProxy
    If Not proxy.SettingsSheet.EnableAddCustomerAccounts Then
        MsgBox MSG_FeatureDisabled, vbExclamation
        Exit Sub
    End If

    With New AccountsPresenter.Present proxy
    End With
End Sub
```

Abstraction prevents projects from becoming unscalable, unmaintainable copy-paste implementations.
