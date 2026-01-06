---
id: 3C85-62C0-8A73-4CFB-9B7D-E06E-DF64-C26A
name: oop-battleship-part-1-the-patterns
title: "OOP Battleship Part 1: The Patterns"
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
url: https://rubberduckvba.blog/2018/08/28/oop-battleship-part-1-the-patterns/
created_at: 2025-11-19T08:43:08
---
# OOP Battleship Part 1: The Patterns

### About OOP

VBA is capable of object-oriented code. This project illustrates factory methods, unit testing, and Model-View-Controller architecture.

VBA code that works can be written without class modules. OOP provides another tool for large projects requiring scaling and maintenance over years—mission-critical projects where structure and architecture matter more than implementation details. Easy extensibility is paramount. These projects benefit most from OOP.

Object-oriented VBA code ports more easily to other languages than procedural VBA code, especially with unit test coverage unavailable for traditional procedural code. OOP VBA code reads similarly to VB.NET, differing only syntactically. If mission-critical VBA projects reach IT departments, they will appreciate neatly identified components, clearly separated responsibilities, and thorough test suite documentation.

OOP is unnecessary for working Battleship games in VBA. However, as a metaphor for business-critical complex applications, OOP facilitates:
- Human player on Grid1 or Grid2
- AI player on both grids
- Different AI difficulty levels/strategies
- Excel UI replacement with Word, Access, or PowerPoint

These are achievable with minimal, inconsequential changes to existing code.

Such changing requirements easily become nightmares even with clean procedural code. Adhering to SOLID OOP principles makes extending games significantly easier.

### PredeclaredId / default instance

The `VB_PredeclaredId = True` attribute creates a default instance:

```vba
VERSION 1.0 CLASS
BEGIN
MultiUse = -1 'True
END
Attribute VB_Name = "StaticClass1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
```

This attribute enables default instances. Avoid storing instance state in default instances. Use for pure functions like factory methods.

Every object receives an ID. `New` creates new object IDs. `VB_PredeclaredId = True` pre-declares an ID for an object named after the class.

### Interfaces

The `Implements` keyword enables classes to present different public interfaces to clients. This allows public mutators on classes while exposing only public accessors to client code written against interfaces.

Interfaces are contracts. Anything implementing an interface must provide required methods without restrictions on implementation. Implementations are swappable at any time; programs work with implementations unaware of details.

Interfaces enable polymorphism—an OOP pillar. Every object exposes an interface: public members constitute the interface. `Implements` allows classes to be accessed through interfaces.

Modeling grid coordinates requires `X` and `Y` properties. Should `Public Property Let` members expose these? `GridCoord` allows it; `IGridCoord` interface denies it, making code against `IGridCoord` read-only. Read-only through interfaces is desirable—the closest VBA gets to immutable types.

VBA interfaces are class modules with public member stubs. The `IPlayer` interface:

```vba
'@Folder("Battleship.Model.Player")
Option Explicit

Public Enum PlayerType
HumanControlled
ComputerControlled
End Enum

Public Property Get PlayGrid() As PlayerGrid
End Property

Public Property Get PlayerType() As PlayerType
End Property

Public Function Play(ByVal enemyGrid As PlayerGrid) As IGridCoord
End Function

Public Sub PlaceShip(ByVal currentShip As IShip)
End Sub
```

Anything with `Implements IPlayer` must implement these members—`HumanPlayer` or `AIPlayer`.

`AIPlayer` implementation excerpt:

```vba
Private Sub IPlayer_PlaceShip(ByVal currentShip As IShip)
    this.Strategy.PlaceShip this.PlayGrid, currentShip
End Sub

Private Function IPlayer_Play(ByVal enemyGrid As PlayerGrid) As IGridCoord
    Set IPlayer_Play = this.Strategy.Play(enemyGrid)
End Function
```

`HumanPlayer` differs completely but both are acceptable `IPlayer` implementations.

### Factory Method

VBA disallows parameterized class initialization. Instances require creation then initialization. Factory methods on default instances enable parameterized `Create` functions returning ready-to-use instances:

```vba
Dim position As IGridCoord
Set position = GridCoord.Create(4, 2)
```

Factory methods create class instances. Their sole purpose is instance creation—a factory pattern. Abstract factories involve classes creating instances of classes implementing interfaces, providing greater abstraction. Simple factory methods suffice for most cases in this project.

```vba
Public Function Create(ByVal xPosition As Long, ByVal yPosition As Long) As IGridCoord
    With New GridCoord.X = xPosition.Y = yPosition
        Set Create =.Self
    End With
End Function

Public Property Get Self() As IGridCoord
    Set Self = Me
End Property
```

`GridCoord` exposes `Property Let` members for `X` and `Y`. `IGridCoord` exposes only `Property Get` accessors. Consistently writing client code against abstract interfaces (not concrete `GridCoord` classes) effectively creates read-only objects, making code intent explicit.

### Model-View-Controller

This widespread architectural pattern separates concerns:
- Model: game data/state (players, grids, ships, cell contents)
- View: component presenting model to users, implementing commands from controller, exposing events controller handles
- Controller: central coordinator telling view to begin new games, responding to view user interaction events

Controller knows model and view. View knows model. Model knows neither view nor controller—just data.

### Adapter

The adapter pattern creates abstraction layers between controller and view, enabling controller interaction with anything implementing required interfaces. Controllers remain unaware whether views are `Excel.Worksheet`, `MSForms.Userform`, `PowerPoint.Slide`, or other types. As long as contracts are respected, anything can be the view.

View implementations have unique public interfaces possibly incompatible with controller expectations. Adapters conform to expected interfaces, like electrical adapters converting one interface to another. As long as `IViewCommands` is implemented, controllers communicate with it.
