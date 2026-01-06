---
id: FED5-509B-AE52-49EC-9627-3820-D7B4-7C7E
name: oop-design-patterns-the-builder
title: "OOP Design Patterns: The Builder"
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
url: https://rubberduckvba.blog/2018/07/03/oop-design-patterns-the-builder/
created_at: 2025-11-19T08:43:08
---
# OOP Design Patterns: The Builder

## Pattern Overview

The Builder Pattern addresses object creation when a factory method would require excessive parameters. The pattern enables chained member calls that construct an object through a fluent interface. Each builder method returns `Me`, allowing statement chaining:

```vba
Set pizza = builder _.OfSize(Medium) _.CrustType = Classic _.WithPepperoni _.WithCheese(Mozza) _.WithPeppers _.WithMushrooms _.Build
```

The `Build` method returns the constructed product object.

## Basic Implementation

```vba
Private result As Pizza

Private Sub Class_Initialize()
    Set result = New Pizza
End Sub

Public Function OfSize(ByVal sz As PizzaSize) As PizzaBuilder
    If result.Size = Unspecified Then
        result.Size = sz
    Else
        Err.Raise 5, TypeName(Me), "Size was already specified"
    End If
    Set OfSize = Me
End Function

Public Function WithPepperoni() As PizzaBuilder
    result.Toppings.Add(Pepperoni)
    Set WithPepperoni = Me
End Function

Public Function Build() As IPizza
    Set Build = result
End Function
```

Builder methods return `Me` and may include validation logic to maintain valid state. The `Build` function returns the encapsulated `result` object.

When `Build` returns an interface type, calling code can treat all implementations polymorphically. The interface can expose only `Property Get` members, preventing direct state modification.

## Design Considerations

- **No temporal coupling**: Builder method invocation order should not affect outcome
- **Builder methods may not be invoked**: Provide sensible defaults or use parameterized factories for required values
- **Repeated invocations**: Handle multiple calls to the same builder method gracefully
- **Readability**: Apply the pattern only when it improves code comprehension

The Builder Pattern proves valuable when factory methods accumulate numerous parameters that obscure call site readability.

The Gang of Four Builder Pattern extends this concept with abstract builders. See [Design Patterns: Elements of Reusable Object-Oriented Software](http://rads.stackoverflow.com/amzn/click/0201633612) and [this SoftwareEngineering.SE answer](https://softwareengineering.stackexchange.com/a/345704/68834) for the canonical implementation.
