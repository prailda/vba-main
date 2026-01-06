---
id: EBBC-3D2E-EEF4-4E4D-A5FE-229E-942E-0D85
name: state-as-a-service
title: State as a Service
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
url: https://rubberduckvba.blog/2024/08/31/state-as-a-service/
created_at: 2025-11-19T08:43:12
---
# State as a Service

## Abstracting Worksheet Settings

When a worksheet contains a table of settings that a macro needs to access, the problem becomes: how to retrieve these values efficiently and consistently without scattering access logic throughout the codebase.

For a ListObject table in a specific worksheet, define it as a property of the worksheet module to formalize its existence:

```vba
Private Const TableName As String = "Table1"

Public Property Get SettingsTable() As ListObject
  Static Value As ListObject
  If Value Is Nothing Then
    On Error Resume Next
      Set Value = Me.ListObjects(TableName)
    On Error GoTo 0
  End If
  Set SettingsTable = Value
End Property
```

Property Get procedures typically do not raise errors. If the table doesn't exist, the property returns Nothing, causing the calling code to raise error 91 as expected. The Static local declaration retains module-scoped behavior without requiring a module-level variable, necessary only when no setter exists.

The Static keyword in VBA means "shared" (similar to "Shared" in VB.NET), causing local variables to retain their value between procedure calls. Using Static at procedure level makes all locals behave this way, which is generally inadvisable.

## Formalizing Access

Without formalized access, different parts of the codebase may retrieve settings using `Application.VLookup`, loops over `SettingsTable.Rows`, `SettingsTable.DataBodyRange.Find`, or other inconsistent methods. This inconsistency creates maintenance problems.

Reading from a Range is nearly as expensive as writing to one. Macros that perform well limit interactions with worksheets and the Excel object model.

## Service Encapsulation

The solution involves iterating the table rows once, yielding an OptionValue class instance for each setting. The OptionValue class defines a Name (String) and Value (Variant) property.

A SettingsService class encapsulates this operation, abstracting away worksheet details and exposing only OptionValue objects. The service reads settings once from the worksheet (during Initialize), caches them in a private keyed collection or dictionary, and returns cached values for subsequent requests without hitting the worksheet.

```vba
Dim Settings As SettingsService
Set Settings = New SettingsService
If Settings.GetBoolean("SomeSetting") Then
  Debug.Print "SomeSetting is ON"
Else
  Debug.Print "SomeSetting is OFF"
End If
```

Typed methods like GetBoolean, GetDate, GetDouble, GetInteger, and GetString ensure type safety. These methods throw errors if the setting doesn't exist or if the Variant subtype doesn't match the expected data type, keeping Variant values completely encapsulated within the service.

## There is no Worksheet

Only the SettingsService needs to access SettingsSheet. The service fully abstracts the worksheet away, allowing the macro to function even if the worksheet doesn't exist (assuming proper error handling for missing settings).

Settings could be moved to a flat file, another workbook, or a database by changing only one method: the one that reads and caches settings. The rest of the codebase remains unchanged because all responsibility is delegated to the service.

This approach contrasts sharply with changing inline VLookups and Range.Find calls throughout the codebase to read from another source.

Code that controls every detail at the lowest level becomes tedious and heavy. The signal drowns in noise, obscuring the procedure's role.

A service class is not strictly necessary. Any distinct procedure scope responsible for retrieving a valid setting value is progress. However, moving state into an object enables better lifetime control. Encapsulating behavior cleans up calling modules the same way extracting procedures cleans up larger scopes. This reduces cognitive load and complexity by relocating peripheral concerns, increasing cohesion by keeping unrelated code elsewhere.
