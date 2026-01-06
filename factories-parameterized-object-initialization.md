---
id: 8826-D80B-3BF3-4D8A-81F0-02E6-78EF-A412
name: factories-parameterized-object-initialization
title: "Factories: Parameterized Object Initialization"
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
url: https://rubberduckvba.blog/2018/04/24/factories-parameterized-object-initialization/
created_at: 2025-11-19T08:43:04
---
# Factories: Parameterized Object Initialization

Creating objects with `Set foo = New Something` assigns an object reference to a variable declared as `Dim foo As Something`.

### With New

Initializing object properties often follows this pattern:

```vba
Dim foo As Something
Set foo = New Something
With foo.Bar = 42.Ducky = "Quack"
End With
```

A `Self` property returning the instance enables `With New` syntax:

```vba
Public Property Get Self() As Something
    Set Self = Me
End Property
```

This allows:

```vba
Dim foo As Something
With New Something.Bar = 42.Ducky = "Quack"
    Set foo =.Self
End With
```

The `With` block holds the object reference. Without the `Self` property, a local variable is required because `With` blocks do not provide handles to held references.

Factory method implementation:

```vba
Public Function NewSomething(ByVal initialBar As Long, ByVal initialDucky As String) As Something
    With New Something.Bar = initialBar.Ducky = initialDucky
        Set NewSomething =.Self
    End With
End Function
```

Calling code:

```vba
Dim foo As Something
Set foo = Factories.NewSomething(42, "Quack")
```

Factory methods reside in standard modules named explicitly (e.g., `Factories`) to indicate their location without navigation.

### Where to put it?

VBA lacks constructors, requiring factory methods instead. The optimal location for factory methods is on the class itself, accessed via the default instance:

```vba
Dim foo As Something
Set foo = Something.Create(42, "Quack")
```

The instance is automatically created by VBA through the `VB_PredeclaredId` attribute:

```vba
VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Something"
Attribute VB_PredeclaredId = True    '<~ HERE!
```

Setting `VB_PredeclaredId` to `True` creates a global-scope default instance. Storing state in this instance leads to bugs; it should contain only factory methods.

### Interfaces

Two interfaces exist: the factory and the instance interface. The factory should not access instance data but must access properties of created objects.

Define an interface:

```vba
VERSION 1.0 CLASS
Attribute VB_Name = "ISomething"
Option Explicit

Public Property Get Bar() As Long
End Property

Public Property Get Ducky() As String
End Property
```

The implementing class:

```vba
VERSION 1.0 CLASS
Attribute VB_Name = "Something"
Attribute VB_PredeclaredId = True
Option Explicit
Private Type TSomething
    Bar As Long
    Ducky As String
End Type

Private this As TSomething
Implements ISomething

Public Function Create(ByVal initialBar As Long, ByVal initialDucky As String) As ISomething
    With New Something.Bar = initialBar.Ducky = initialDucky
        Set Create =.Self
    End With
End Function

Public Property Get Self() As ISomething
    Set Self = Me
End Property

Public Property Get Bar() As Long
    Bar = this.Bar
End Property

Friend Property Let Bar(ByVal value As Long)
    this.Bar = value
End Property

Public Property Get Ducky() As String
    Ducky = this.Ducky
End Property

Friend Property Let Ducky(ByVal value As String)
    this.Ducky = value
End Property

Private Property Get ISomething_Bar() As Long
    ISomething_Bar = Bar
End Property

Private Property Get ISomething_Ducky() As String
    ISomething_Ducky = Ducky
End Property
```

The `Friend` properties are project-accessible only. Calling code interacts solely with the `ISomething` interface:

```vba
With Something.Create(42, "Quack")
    Debug.Print.Bar 'prints 42.Bar = 42 'illegal, member not on interface
End With
```

Calling code remains tightly coupled with `Something`. A factory interface provides abstraction:

```vba
VERSION 1.0 CLASS
Attribute VB_Name = "ISomethingFactory"
Option Explicit

Public Function Create(ByVal initialBar As Long, ByVal initialDuck As String) As ISomething
End Function
```

Implement the factory interface:

```vba
Implements ISomething
Implements ISomethingFactory

Public Function Create(ByVal initialBar As Long, ByVal initialDucky As String) As ISomething
    With New Something.Bar = initialBar.Ducky = initialDucky
        Set Create =.Self
    End With
End Function

Private Function ISomethingFactory_Create(ByVal initialBar As Long, ByVal initialDucky As String) As ISomething
    Set ISomethingFactory_Create = Create(initialBar, initialDucky)
End Function
```

This creates an abstract factory for passing to any code requiring `Something` instances:

```vba
Option Explicit

Public Sub Main()
    Dim factory As ISomethingFactory
    Set factory = Something.Self
    With MyMacro.Create(factory).Run
    End With
End Sub
```

Factories enable parameterized object creation and abstract the creation concept itself. Concrete implementations become irrelevant; only interfaces matter.

Using interfaces segregates API parts into different object views. Factory methods with coding conventions achieve get-only properties assignable only during initialization.

Coding against interfaces facilitates unit testing by decoupling logic from database connections, SQL queries, data presence, network connectivity, and other uncontrollable external factors.

Abstract factories, factory methods, and interfaces are valuable tools for large, maintainable projects requiring extensibility and proper architecture.
