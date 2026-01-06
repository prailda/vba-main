---
id: 6E66-BE3B-7D91-40C6-BD85-7A52-2F97-5AEB
name: password-authentication
title: Password Authentication
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
url: https://rubberduckvba.blog/2020/02/06/password-authentication/
created_at: 2025-11-19T08:43:08
---
# Password Authentication

## Threat Model Assessment

Application authentication goals determine security requirements:

Valid use cases for lightweight authentication:
- Enhancing user experience with tailored functionality
- Grouping users into roles for management
- Preventing accidental feature misuse

Invalid assumptions for VBA security:
- Preventing intentional misuse
- Securing user access to functionalities
- Any security-critical protection

VBA code lacks inherent security. Password-protected VBE projects can be [unlocked via Win32 API](https://stackoverflow.com/a/27508116/1188513). The threat model must account for determined users accessing source code.

## Password Storage

Hard-coded passwords expose credentials in VBA project binary data, viewable in uncompressed host documents via text editors.

Never store passwords in any form. Store salted password hashes exclusively.

### Hashing vs Encryption

Hash functions convert input to fixed-length output irreversibly. SHA256 hash of `password`:

```
5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
```

No process reverses hashes to original strings. Hash collision possibility exists but remains extremely unlikely with SHA256 or higher.

Cryptographically secure hashing uses slow algorithms producing low-collision values, increasing brute-force difficulty. MD5 hashes provide speed but insufficient security for passwords.

### Salt Values

Identical passwords produce identical hashes. Salt values prevent rainbow table attacks: prepend random string to password before hashing. Unique salts per user prevent password pattern identification from hash comparison.

Store salt alongside hash. Compromised salt+hash pairs remain secure; attackers cannot determine original passwords.

## VBA Hashing Implementation

Leverage .NET Framework via late binding for cryptographic functions:

```vba
Public Function ComputeHash(ByVal value As String) As String
    Dim bytes() As Byte
    bytes = StrConv(value, vbFromUnicode)

    Dim algo As Object
    Set algo = CreateObject("System.Security.Cryptography.SHA256Managed")

    Dim buffer() As Byte
    buffer = algo.ComputeHash_2(bytes)

    ComputeHash = ToHexString(buffer)
End Function

Private Function ToHexString(ByRef buffer() As Byte) As String
    Dim result As String
    Dim i As Long
    For i = LBound(buffer) To UBound(buffer)
        result = result & Hex(buffer(i))
    Next
    ToHexString = result
End Function
```

Use `ComputeHash_2` overload for byte array parameters. COM exposes .NET overloads with numeric suffixes.

## Object-Oriented Implementation

### IHashAlgorithm Interface

```vba
'@Folder("Authentication.Hashing")
'@Interface
Option Explicit

Public Function ComputeHash(ByVal value As String) As String
End Function
```

### SHA256Managed Implementation

```vba
'@Folder("Authentication.Hashing")
'@PredeclaredId
Option Explicit
Implements IHashAlgorithm
Private base As HashAlgorithmBase

Public Function Create() As IHashAlgorithm
    Set Create = New SHA256Managed
End Function

Private Sub Class_Initialize()
    Set base = New HashAlgorithmBase
End Sub

Private Function IHashAlgorithm_ComputeHash(ByVal value As String) As String
    Dim bytes() As Byte
    bytes = StrConv(value, vbFromUnicode)

    Dim algo As Object
    Set algo = CreateObject("System.Security.Cryptography.SHA256Managed")

    Dim buffer() As Byte
    buffer = algo.ComputeHash_2(bytes)

    IHashAlgorithm_ComputeHash = base.ToHexString(buffer)
End Function
```

Interface-based design enables algorithm substitution without client code modification.

### UserAuthModel

```vba
'@Folder("Authentication")
Option Explicit
Private Type TAuthModel
    Name As String
    Password As String
    IsValid As Boolean
End Type
Private this As TAuthModel

Public Property Get IsValid() As Boolean
    IsValid = this.IsValid
End Property

Private Sub Validate()
    this.IsValid = Len(this.Name) > 0 And Len(this.Password) > 0
End Sub
```

### IAuthService

```vba
'@Folder("Authentication")
'@Interface
Option Explicit

Public Function Authenticate(ByVal model As UserAuthModel) As Boolean
End Function
```

### WorksheetAuthService Implementation

```vba
Private Function IAuthService_Authenticate(ByVal model As UserAuthModel) As Boolean
    Dim info As TUserAuthInfo
    If Not model.IsValid Or Not GetUserAuthInfo(model.Name, outInfo:=info) Then Exit Function

    Dim pwdHash As String
    pwdHash = this.Algorithm.ComputeHash(info.Salt & model.Password)

    IAuthService_Authenticate = (pwdHash = info.Hash)
End Function
```

Authentication succeeds when computed salted password hash matches stored hash. Plain-text password never copied or compared.

### IAuthPresenter

```vba
'@Folder("Authentication")
'@Interface
Option Explicit

Public Property Get IsAuthenticated() As Boolean
End Property

Public Sub Authenticate()
End Sub
```

### Implementation

```vba
Private Sub IAuthPresenter_Authenticate()
    If Not this.View.ShowDialog Then Exit Sub
    this.IsAuthenticated = this.AuthService.Authenticate(this.View.UserAuthModel)
End Sub
```

### Composition Root

```vba
Public Sub DoSomething()
    Dim model As UserAuthModel
    Set model = New UserAuthModel

    Dim dialog As IAuthView
    Set dialog = AuthDialogView.Create(model)

    Dim algo As IHashAlgorithm
    Set algo = SHA256Managed.Create()

    Dim service As IAuthService
    Set service = WorksheetAuthService.Create(algo)

    Dim presenter As IAuthPresenter
    Set presenter = AuthPresenter.Create(service, dialog)

    presenter.Authenticate
    If presenter.IsAuthenticated Then
        MsgBox "Welcome!", vbInformation
    Else
        MsgBox "Access denied", vbExclamation
    End If
End Sub
```

## Authorization

Role-based authorization extends authentication. Users belong to groups; groups receive authorizations.

Define roles via enum:

```vba
Public Enum AuthRole
    Unauthorized = 0
    Admin
    Maintenance
    Auditing
End Enum
```

Modify `IAuthService.Authenticate` to return `Long` role ID (0 for failure). Query Active Directory security groups for enterprise implementations.

## SQL Injection Prevention

Database queries require parameterization. User `Tom O'Neil` breaks string concatenation queries. Use `ADODB.Command` with proper parameter handling regardless of authentication method.

Plain-text password comparison remains incorrect regardless of implementation language or storage medium.

Complete code: [https://github.com/rubberduck-vba/examples/tree/master/Authentication](https://github.com/rubberduck-vba/examples/tree/master/Authentication)
