---
id: 16E7-9775-84D3-47B7-A4C6-4D96-7A66-8F70
name: understanding-me-no-flowers-no-bees
title: Understanding 'Me' (no flowers, no bees)
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
url: https://rubberduckvba.blog/2018/09/05/understanding-me-no-flowers-no-bees/
created_at: 2025-11-19T08:43:13
---
# Understanding 'Me' (no flowers, no bees)

## Me as a Reserved Name

Me is commonly misunderstood as a keyword or a special object built into Excel, or inferred to be some kind of hidden instance/module-level variable only present in class/form/document modules. The language specifications clarify (emphasis added):

> Within the `<procedure-body>` of a procedure declaration that is defined within a `<class-module-code-section>` the declared type of the reserved name **Me** is the named class defined by the enclosing class module and the data value of **Me** is an object reference to *the object that is the target object of the currently active invocation of the function*.

Me is a reserved name existing only in procedure scope. The type being the class it's used in enables IntelliSense to know the members, but its value is ultimately provided by the caller. From section 5.3.1.5 "Parameter lists":

> Each procedure that is a method has an **implicit ByVal parameter** called the *current object* that corresponds to the target object of an invocation of the method. The current object acts as an anonymous local variable with procedure extent and whose declared type is the class name of the class module containing the method declaration. […]

When this code executes:

```vba
Dim foo As Class1
Set foo = New Class1
foo.DoSomething 42
```

What actually happens under the hood is:

```vba
Dim foo As Class1
Set foo = New Class1
Class1.DoSomething foo, 42
```

Every parameterless method written like this:

```vba
Public Sub DoSomething()
End Sub
```

Is understood by VBA as this (assuming the method is in Class1):

```vba
Public Sub DoSomething(ByVal Me As Class1)
End Sub
```

This is the same mechanics as the this pointer in C++.

Me isn't a magic keyword and has nothing to do with Excel (or any VBA host application). Me is simply a reserved name allowing reference to this hidden current object pointer inside a procedure scope. That current object is whichever instance of the current class the calling code is working with.
