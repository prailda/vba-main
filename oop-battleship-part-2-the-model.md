---
id: 6DE9-D424-F7F0-4CDA-BE1A-D412-82AF-3D7C
name: oop-battleship-part-2-the-model
title: "OOP Battleship Part 2: The Model"
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
url: https://rubberduckvba.blog/2018/09/03/oop-battleship-part-2-the-model/
created_at: 2025-11-19T08:43:08
---
# OOP Battleship Part 2: The Model

## Model Architecture

The Model-View-Controller pattern requires objects that represent problem domain entities:

- **Player**: Identifies human or computer-controlled participant with associated grid
- **PlayerGrid**: Tracks player grid state and contains ships
- **Ship**: Encapsulates size, orientation, position, hit locations, and sunk status
- **GridCoordinate**: Represents X,Y positions with offset calculation capability

These objects encapsulate game state. The controller manages player turns; the view handles display and user input. The model isolates data manipulation concerns.

## GridCoordinate Implementation

Grid coordinates are immutable: once created, position values remain constant. The `IGridCoord` interface provides coordinate comparison, adjacency testing, and string representation in both (x,y) and A1 notation:

```vba
'@Folder("Battleship.Model")
'@Description("Describes a coordinate in a 2D grid.")
'@Interface
Option Explicit

Public Property Get X() As Long
End Property

Public Property Get Y() As Long
End Property

Public Function Offset(Optional ByVal xOffset As Long, Optional ByVal yOffset As Long) As IGridCoord
End Function

Public Function IsAdjacent(ByVal other As IGridCoord) As Boolean
End Function

Public Function Equals(ByVal other As IGridCoord) As Boolean
End Function

Public Function ToString() As String
End Function

Public Function ToA1String() As String
End Function
```

The interface enables read-only X and Y exposure. Code targets the `IGridCoord` interface rather than the concrete `GridCoord` class.

The class uses a predeclared ID to expose factory methods from its default instance:

```vba
VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "GridCoord"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
'@Folder("Battleship.Model")
Option Explicit
Implements IGridCoord

Private Type TGridCoord
    X As Long
    Y As Long
End Type

Private this As TGridCoord

Public Function Create(ByVal xPosition As Long, ByVal yPosition As Long) As IGridCoord
    With New GridCoord
        .X = xPosition
        .Y = yPosition
        Set Create = .Self
    End With
End Function

Public Function FromString(ByVal coord As String) As IGridCoord
    coord = Replace(Replace(coord, "(", vbNullString), ")", vbNullString)

    Dim coords As Variant
    coords = Split(coord, ",")

    If UBound(coords) - LBound(coords) + 1 <> 2 Then Err.Raise 5, TypeName(Me), "Invalid format string"

    Dim xPosition As Long
    xPosition = coords(LBound(coords))

    Dim yPosition As Long
    yPosition = coords(UBound(coords))

    Set FromString = Create(xPosition, yPosition)
End Function

Public Property Get Self() As IGridCoord
    Set Self = Me
End Property

Private Function IGridCoord_Equals(ByVal other As IGridCoord) As Boolean
    IGridCoord_Equals = other.X = this.X And other.Y = this.Y
End Function

Private Function IGridCoord_IsAdjacent(ByVal other As IGridCoord) As Boolean
    If other.Y = this.Y Then
        IGridCoord_IsAdjacent = other.X = this.X - 1 Or other.X = this.X + 1
    ElseIf other.X = this.X Then
        IGridCoord_IsAdjacent = other.Y = this.Y - 1 Or other.Y = this.Y + 1
    End If
End Function
```

Usage:

```vba
Dim position As IGridCoord
Set position = GridCoord.Create(3, 4)
Debug.Print position.ToA1String
```

## PlayerGrid Implementation

The `PlayerGrid` class represents each player's grid with a `GridState` array and ship collection:

```vba
VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "PlayerGrid"
'@Folder("Battleship.Model.Player")
Option Explicit

Private Const GridSize As Byte = 10
Private Const MaxShipsPerGrid As Byte = 5

Public Enum AttackResult
    Miss
    Hit
    Sunk
End Enum

Public Enum GridState
    Unknown = -1
    PreviewShipPosition = 0
    ShipPosition = 1
    InvalidPosition = 2
    PreviousMiss = 3
    PreviousHit = 4
End Enum

Private Type TPlayGrid
    Id As Byte
    ships As Collection
    State(1 To GridSize, 1 To GridSize) As GridState
End Type

Private this As TPlayGrid
```

### TryHit Method

Sets internal state to `PreviousHit` or `PreviousMiss` based on ship presence, returning the affected ship by reference:

```vba
Public Function TryHit(ByVal position As IGridCoord, Optional ByRef hitShip As IShip) As AttackResult
    If this.State(position.X, position.Y) = GridState.PreviousHit Or _
       this.State(position.X, position.Y) = GridState.PreviousMiss Then
        Err.Raise PlayerGridErrors.KnownGridStateError, TypeName(Me), KnownGridStateErrorMsg
    End If

    Dim currentShip As IShip
    For Each currentShip In this.ships
        If currentShip.Hit(position) Then
            this.State(position.X, position.Y) = GridState.PreviousHit
            If currentShip.IsSunken Then
                TryHit = Sunk
            Else
                TryHit = Hit
            End If
            Set hitShip = currentShip
            Exit Function
        End If
    Next

    this.State(position.X, position.Y) = GridState.PreviousMiss
    TryHit = Miss
End Function
```

### FindHitArea Method

Returns collections of previously hit positions for AI ship hunting:

```vba
Public Function FindHitArea() As Collection
    Dim currentShip As IShip
    For Each currentShip In this.ships
        If Not currentShip.IsSunken Then
            Dim currentAreas As Collection
            Set currentAreas = currentShip.HitAreas
            If currentAreas.Count > 0 Then
                Set FindHitArea = currentAreas(1)
                Exit Function
            End If
        End If
    Next
End Function
```

### Scramble Method

Hides AI ship positions by replacing confirmed positions with unknown states:

```vba
Public Sub Scramble()
    Dim currentX As Long
    For currentX = 1 To GridSize
        Dim currentY As Long
        For currentY = 1 To GridSize
            If this.State(currentX, currentY) = GridState.ShipPosition Then
                this.State(currentX, currentY) = GridState.Unknown
            End If
        Next
    Next
End Sub
```

## Player Interface

The `IPlayer` interface defines player capabilities:

```vba
'@Folder("Battleship.Model.Player")
'@Interface
Option Explicit

Public Enum PlayerType
    HumanControlled
    ComputerControlled
End Enum

Public Property Get PlayerType() As PlayerType
End Property

Public Property Get PlayGrid() As PlayerGrid
End Property

Public Sub PlaceShip(ByVal currentShip As IShip)
End Sub

Public Function Play(ByVal enemyGrid As PlayerGrid) As IGridCoord
End Function
```

### AIPlayer Implementation

The `AIPlayer` delegates strategy to an injected `IGameStrategy`:

```vba
VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "AIPlayer"
Attribute VB_PredeclaredId = True
'@Folder("Battleship.Model.Player")
Option Explicit
Implements IPlayer

Private Type TPlayer
    GridIndex As Byte
    PlayerType As PlayerType
    PlayGrid As PlayerGrid
    Strategy As IGameStrategy
End Type

Private this As TPlayer

Public Function Create(ByVal gridId As Byte, ByVal GameStrategy As IGameStrategy) As IPlayer
    With New AIPlayer
        .PlayerType = ComputerControlled
        .GridIndex = gridId
        Set .Strategy = GameStrategy
        Set .PlayGrid = PlayerGrid.Create(gridId)
        Set Create = .Self
    End With
End Function

Private Sub IPlayer_PlaceShip(ByVal currentShip As IShip)
    this.Strategy.PlaceShip this.PlayGrid, currentShip
End Sub

Private Function IPlayer_Play(ByVal enemyGrid As PlayerGrid) As IGridCoord
    Win32API.Sleep Delay
    Set IPlayer_Play = this.Strategy.Play(enemyGrid)
End Function
```

Polymorphism enables strategy injection: extending AI behavior requires no changes to `AIPlayer` code.
