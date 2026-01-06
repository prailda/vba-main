---
id: FB54-6B03-6460-4BE4-A1EC-F415-F21B-4DCD
name: lazy-object-weak-reference
title: Lazy Object / Weak Reference
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
url: https://rubberduckvba.blog/2018/09/11/lazy-object-weak-reference/
created_at: 2025-11-19T08:43:06
---
# Lazy Object / Weak Reference

Classes sometimes require references to "owner" objects—the objects creating them. Owner objects often hold references to all created "child" objects. If `Class1` is parent and `Class2` is child:

```vba
'Class1
Option Explicit
Private children As VBA.Collection

Public Sub Add(ByVal child As Class2)
    Set child.Owner = Me
    children.Add child
End Sub

Private Sub Class_Initialize()
    Set children = New VBA.Collection
End Sub

Private Sub Class_Terminate()
    Debug.Print TypeName(Me) & " is terminating"
End Sub
```

`Class2`:

```vba
'Class2
Option Explicit
Private parent As Class1

Public Property Get Owner() As Class1
    Set Owner = parent
End Property

Public Property Set Owner(ByVal value As Class1)
    Set parent = value
End Property

Private Sub Class_Terminate()
    Debug.Print TypeName(Me) & " is terminating"
End Sub
```

This creates a memory leak bug. This code produces no debug output despite `Class_Terminate` handlers:

```vba
'Module1
Option Explicit

Public Sub Test()
    Dim foo As Class1
    Set foo = New Class1
    foo.Add New Class2
    Set foo = Nothing
End Sub
```

Both objects remain in memory, outliving `Test` procedure scope. This can escalate from sloppy object management to serious bugs leaving ghost processes requiring Task Manager termination.

Not keeping `Class1` references in `Class2` fixes this but breaks `Class2` functionality.

Abstract the concept of holding object references. Instead of holding object references, hold `Long` integers representing addresses of object pointer locations. Hold tickets indicating object locations rather than objects themselves.

Define an `IWeakReference` interface encapsulating object reference concept:

```vba
'@Interface
Option Explicit

Public Property Get Object() As Object
End Property
```

Implement with `WeakReference` class using Win32 API `CopyMemory` to copy bytes at given addresses into usable object references:

```vba
VERSION 1.0 CLASS
Attribute VB_Name = "WeakReference"
Attribute VB_PredeclaredId = True
Option Explicit
Implements IWeakReference

#If Win64 Then
Private Declare PtrSafe Sub CopyMemory Lib "kernel32.dll" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As LongPtr)
#Else
Private Declare Sub CopyMemory Lib "kernel32.dll" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)
#End If

Private Type TReference
#If VBA7 Then
    Address As LongPtr
#Else
    Address As Long
#End If
End Type

Private this As TReference

Public Function Create(ByVal instance As Object) As IWeakReference
    With New WeakReference.Address = ObjPtr(instance)
        Set Create =.Self
    End With
End Function

Public Property Get Self() As IWeakReference
    Set Self = Me
End Property

#If VBA7 Then
Public Property Get Address() As LongPtr
#Else
Public Property Get Address() As Long
#End If
    Address = this.Address
End Property

#If VBA7 Then
Public Property Let Address(ByVal Value As LongPtr)
#Else
Public Property Let Address(ByVal Value As Long)
#End If
    this.Address = Value
End Property

Private Property Get IWeakReference_Object() As Object
#If VBA7 Then
    Dim pointerSize As LongPtr
#Else
    Dim pointerSize As Long
#End If

    On Error GoTo CleanFail
    pointerSize = LenB(this.Address)

    Dim obj As Object
    CopyMemory obj, this.Address, pointerSize

    Set IWeakReference_Object = obj
    CopyMemory obj, 0&, pointerSize

CleanExit:
    Exit Property

CleanFail:
    Set IWeakReference_Object = Nothing
    Resume CleanExit
End Property
```

Toggle `VB_PredeclaredId` for default instance. Factory method creates and returns `IWeakReference` given object references. Store object pointer addresses using `ObjPtr` into private instance fields. Implement `IWeakReference.Object` getter returning `Nothing` instead of bubbling run-time errors.

`Class2` now holds indirect references to `Class1`:

```vba
'Class2
Option Explicit
Private parent As IWeakReference

Public Property Get Owner() As Class1
    Set Owner = parent.Object
End Property

Public Property Set Owner(ByVal Value As Class1)
    Set parent = WeakReference.Create(Value)
End Property

Private Sub Class_Terminate()
    Debug.Print TypeName(Me) & " is terminating"
End Sub
```

`Module1.Test` produces expected output; memory leak is fixed:

```
Class1 is terminating
Class2 is terminating
```
