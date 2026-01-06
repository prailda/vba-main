---
id: 363F-9E07-66D2-4DDE-9C99-0E91-4213-BF4A
name: builder-walkthrough
title: Builder Walkthrough
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
url: https://rubberduckvba.blog/2020/05/29/builder-walkthrough/
created_at: 2025-11-19T08:43:02
---
# Builder Walkthrough

Default instance factory methods enable initialization of classes at appropriate abstraction levels. Classes requiring initialization with many values (a dozen or more) benefit from alternative patterns. Example code resides in the Rubberduck Examples repository.

### A Class with Many Properties

Entity objects representing database records commonly have many properties. Creating a `User` class begins with public fields for each property:

```vba
Option Explicit
Public Id As String
Public UserName As String
Public FirstName As String
Public LastName As String
Public Email As String
Public EmailVerified As Boolean
Public TwoFactorEnabled As Boolean
Public PhoneNumber As String
Public PhoneNumberVerified As Boolean
Public AvatarUrl As String
```

Using Rubberduck's Encapsulate Field refactoring (Ctrl+Shift+F), select all fields and enable "wrap fields in private type" to generate:

```vba
Option Explicit
Private Type TUser
    Id As String
    UserName As String
    FirstName As String
    LastName As String
    Email As String
    EmailVerified As Boolean
    TwoFactorEnabled As Boolean
    PhoneNumber As String
    PhoneNumberVerified As Boolean
    AvatarUrl As String
End Type
Private this As TUser
Public Property Get Id() As String
    Id = this.Id
End Property
Public Property Let Id(ByVal value As String)
    this.Id = value
End Property
' [Additional properties omitted for brevity]
```

Extract Interface refactoring creates a read-only `IUser` interface by selecting all `Property Get` accessors while skipping `Property Let`. This produces compile-time validation preventing assignments.

The `User` class now implements `IUser` with interface member implementations at the bottom. Extract Interface can automatically implement extracted interfaces.

A predeclared instance with a `Create` factory method could take all parameters:

```vba
'@Description "Creates and returns a new user instance with the specified property values."
Public Function Create(ByVal Id As String, ByVal UserName As String,...) As IUser
    '...
End Function
```

Rubberduck's `@PredeclaredId` annotation simplifies creating predeclared instances. Adding `'@PredeclaredId` at the class top and applying the AttributeValueOutOfSync inspection quick-fix synchronizes the hidden attribute.

Factory methods with 10+ value parameters create unwieldy code:

```vba
Set identity = User.Create("01234", "Rubberduck", "contact@rubberduckvba.com", False,...)
```

Named parameters improve readability but face line continuation limits (~20 parameters):

```vba
Set identity = User.Create( _
    Id:="01234", _
    UserName:="Rubberduck", _
    Email:="contact@rubberduckvba.com", _
    EmailVerified:=False, _
    Phone:="555-555-5555", _
    PhoneVerified:=False, _...)
```

### Building the Builder

Designing objects from the consumer's perspective produces:

```vba
Set identity = UserBuilder.Create("01234", "Rubberduck") _
    .WithEmail("contact@rubberduckvba.com", Verified:=False) _
    .WithPhone("555-555-5555", Verified:=False) _
    .Build
```

The builder pattern solves several problems:
- Optional arguments become explicitly optional member calls; long argument lists are eliminated.
- Required values (`Id`, `UserName`) pass to the builder's `Create` factory method, guaranteeing valid `User` instances.
- Related parameters group together: `WithEmail` and `WithPhone` methods take `Verified` Boolean parameters alongside email/phone, ensuring consistency.

Start with abstractions. Copy `IUser` interface into a new class, replace "Property Get " with "Function With", and replace return types with "IUserBuilder":

```vba
'@Interface
Option Explicit
Public Function WithId() As IUserBuilder
End Function
Public Function WithUserName() As IUserBuilder
End Function
' [Additional methods...]
```

Add a `Build` method returning `IUser`:

```vba
Public Function Build() As IUser
End Function
```

Add parameters and merge related members to define the builder API shape. Rename to `IUserBuilder`:

```vba
'@Interface
'@ModuleDescription("Incrementally builds a User instance.")
Option Explicit
'@Description("Returns the current object.")
Public Function Build() As IUser
End Function
'@Description("Builds a user with a first and last name.")
Public Function WithName(ByVal FirstName As String, ByVal LastName As String) As IUserBuilder
End Function
'@Description("Builds a user with an email address.")
Public Function WithEmail(ByVal Email As String, Optional ByVal Verified As Boolean = False) As IUserBuilder
End Function
'@Description("Builds a user with SMS-based 2FA enabled.")
Public Function WithTwoFactorAuthentication(ByVal PhoneNumber As String, Optional ByVal Verified As Boolean = False) As IUserBuilder
End Function
'@Description("Builds a user with an avatar at the specified URL.")
Public Function WithAvatar(ByVal Url As String) As IUserBuilder
End Function
```

Create another class implementing `IUserBuilder`. Parse with non-compiling code, then use Implement Interface refactoring to generate method stubs:

```vba
Option Explicit
Implements IUserBuilder
Private Function IUserBuilder_Build() As IUser
    Err.Raise 5 'TODO implement interface member
End Function
Private Function IUserBuilder_WithName(ByVal FirstName As String, ByVal LastName As String) As IUserBuilder
    Err.Raise 5 'TODO implement interface member
End Function
' [Additional stubs...]
```

Add `@PredeclaredId` annotation and implement a `Create` factory method taking required values. Each `With` method sets properties and returns `Me` (enabling chaining). Add a `Build` method returning the encapsulated `IUser` object. The completed `UserBuilder`:

```vba
'@PredeclaredId
'@ModuleDescription("Builds a User object.")
Option Explicit
Implements IUserBuilder
Private internal As User
'@Description("Creates a new UserBuilder instance.")
Public Function Create(ByVal Id As String, ByVal UserName As String) As IUserBuilder
    Dim result As UserBuilder
    Set result = New UserBuilder

    Dim obj As User
    Set obj = New User
    obj.Id = Id
    obj.UserName = UserName

    Set result.User = obj
    Set Create = result
End Function
'@Ignore WriteOnlyProperty
'@Description("For property injection of the internal IUser object; only the Create method should be invoking this member.")
Friend Property Set User(ByVal value As IUser)
    If Me Is UserBuilder Then Err.Raise 5, TypeName(Me), "Member call is illegal from default instance."
    If value Is Nothing Then Err.Raise 5, TypeName(Me), "'value' argument cannot be a null reference."
    Set internal = value
End Property
Private Function IUserBuilder_Build() As IUser
    If internal Is Nothing Then Err.Raise 91, TypeName(Me), "Builder initialization error: use UserBuilder.Create to create a UserBuilder."
    Set IUserBuilder_Build = internal
End Function
Private Function IUserBuilder_WithName(ByVal FirstName As String, ByVal LastName As String) As IUserBuilder
    internal.FirstName = FirstName
    internal.LastName = LastName
    Set IUserBuilder_WithName = Me
End Function
Private Function IUserBuilder_WithEmail(ByVal Email As String, Optional ByVal Verified As Boolean = False) As IUserBuilder
    internal.Email = Email
    internal.EmailVerified = Verified
    Set IUserBuilder_WithEmail = Me
End Function
Private Function IUserBuilder_WithTwoFactorAuthentication(ByVal PhoneNumber As String, Optional ByVal Verified As Boolean = False) As IUserBuilder
    internal.TwoFactorEnabled = True
    internal.PhoneNumber = PhoneNumber
    internal.PhoneNumberVerified = Verified
    Set IUserBuilder_WithTwoFactorAuthentication = Me
End Function
Private Function IUserBuilder_WithAvatar(ByVal Url As String) As IUserBuilder
    internal.AvatarUrl = Url
    Set IUserBuilder_WithAvatar = Me
End Function
```

The `Create` method invokes off the class's default instance:

```vba
Set builder = UserBuilder.Create(internalId, uniqueName)
```

Advantages include initializing the builder with required values, enabling immediate `Build` calls producing valid `User` objects.

Rubberduck's ToDo Explorer can track custom markers like "FIXME" in comments for navigation.

The `Friend Property Set User` enables property injection:

```vba
'@Ignore WriteOnlyProperty
Friend Property Set User(ByVal value As IUser)
    If Me Is UserBuilder Then Err.Raise 5, TypeName(Me), "Member call is illegal from default instance."
    If value Is Nothing Then Err.Raise 5, TypeName(Me), "'value' argument cannot be a null reference."
    Set internal = value
End Property
```

The `If Me Is UserBuilder` condition verifies execution context, preventing default instance misuse.

#### Synchronizing Attributes & Annotations

The AttributeValueOutOfSync inspection identifies mismatched attributes and annotations. Fix inspection results to synchronize `VB_PredeclaredId` attributes.

The `UserBuilder` is ready for use:

```vba
Dim identity As IUser
Set identity = UserBuilder.Create(uniqueId, uniqueName) _
    .WithName(first, last) _
    .WithEmail(emailAddress) _
    .Build
```

Misuse scenarios:

```vba
Set UserBuilder.User = New User '<~ runtime error, illegal from default instance
Set builder = New UserBuilder
Set identity = builder.Build '<~ runtime error 91, builder state not initialized
```

### Conclusions

Classes with many properties resist initialization. Required versus optional properties, and interdependent property validity, create complexity. Rubberduck refactorings simplify class creation. The builder creational pattern solves temporal coupling and state issues, enabling fluent APIs that chain optional member calls for complex object construction without extensive parameter lists.
