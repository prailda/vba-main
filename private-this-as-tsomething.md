---
id: 09FB-B09F-E7C2-4D39-85A5-50E4-72EE-888E
name: private-this-as-tsomething
title: Private this As TSomething
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
url: https://rubberduckvba.blog/2018/04/25/private-this-as-tsomething/
created_at: 2025-11-19T08:43:09
---
# Private this As TSomething

## Pattern Overview

Encapsulating class instance fields in a `Private Type` structure with a single `Private this` variable offers advantages over traditional field-per-variable approaches:

```vba
Option Explicit
Private Type TPerson
    FirstName As String
    LastName As String
End Type
Private this As TPerson

Public Property Get FirstName() As String
    FirstName = this.FirstName
End Property

Public Property Let FirstName(ByVal value As String)
    this.FirstName = value
End Property
```

Compared to traditional approach:

```vba
Option Explicit
Private mFirstName As String
Private mLastName As String

Public Property Get FirstName() As String
    FirstName = mFirstName
End Property

Public Property Let FirstName(ByVal pFirstName As String)
    mFirstName = pFirstName
End Property
```

## Advantages

### Naming Consistency

Properties and backing fields use identical identifiers. The UDT prefix (`T`) distinguishes type declarations without conflicting with class names in `As` clauses outside the class module.

### IntelliSense Optimization

Type `this.` to access only backing fields. No Hungarian prefixes intertwine module-level fields with public members.

### Parameter Standardization

Mutator parameters consistently use `ByVal value` convention, eliminating `m`-for-member and `p`-for-parameter confusion.

### Locals Window Organization

The Locals debugging toolwindow groups all fields under collapsed `this` member, separating state from property accessors.

### Binary Serialization

Serialize entire object state with `Put #fileHandle this`. Deserialization: `Get #fileHandle, , this`. No property enumeration required.

### Memory Efficiency

UDT allocates same memory as individual fields. Two `Long` fields total 8 bytes; UDT with two `Long` members totals 8 bytes. Use `Len(this)` to verify class instance field size.

## Objections Addressed

### Collection Compatibility

The encapsulated UDT never enters collections. Class instances enter collections; internal state organization remains invisible to external code.

### Memory Overhead

No additional overhead exists. UDT provides organizational structure without allocation penalty.

### Tooling Support

Rubberduck's encapsulate field refactoring targets individual public fields. Future enhancement could generate property boilerplate from UDT declarations, reducing manual implementation.
