---
id: 5EB5-11D0-B858-4095-A811-7079-5B91-2DDC
name: oop-battleship-part-4-ai-strategies
title: "OOP Battleship Part 4: AI Strategies"
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
url: https://rubberduckvba.blog/2018/09/04/oop-battleship-part-4-ai-strategies/
created_at: 2025-11-19T08:43:08
---
# OOP Battleship Part 4: AI Strategies

## Strategy Pattern Implementation

The `AIPlayer` factory method accepts an `IGameStrategy` parameter for dependency injection:

```vba
Public Function Create(ByVal gridId As Byte, ByVal GameStrategy As IGameStrategy) As IPlayer
    With New AIPlayer
        .PlayerType = ComputerControlled
        .GridIndex = gridId
        Set .Strategy = GameStrategy
        Set .PlayGrid = PlayerGrid.Create(gridId)
        Set Create = .Self
    End With
End Function
```

## Composition Over Inheritance

VBA lacks class inheritance, but composition achieves the same goal. All `IGameStrategy` implementations compose with a `GameStrategyBase` class that provides common functionality:

```vba
Option Explicit
Implements IGameStrategy
Private base As GameStrategyBase

Private Sub Class_Initialize()
    Set base = New GameStrategyBase
End Sub
```

This coupling is intentional, as `GameStrategyBase` exists specifically to support `IGameStrategy` implementations.

## Strategy Implementations

### RandomShotStrategy

Shoots at random coordinates until all enemy ships are located, then destroys them sequentially. Places ships randomly without adjacency checks.

```vba
Private Sub IGameStrategy_PlaceShip(ByVal grid As PlayerGrid, ByVal currentShip As IShip)
    Dim direction As ShipOrientation
    Dim position As IGridCoord
    Set position = base.PlaceShip(Random, grid, currentShip, direction)

    grid.AddShip Ship.Create(currentShip.ShipKind, direction, position)
    If grid.shipCount = PlayerGrid.ShipsPerGrid Then grid.Scramble
End Sub

Private Function IGameStrategy_Play(ByVal enemyGrid As PlayerGrid) As IGridCoord
    Dim position As IGridCoord
    Do
        If EnemyShipsToFind(enemyGrid) > 0 Then
            Set position = base.ShootRandomPosition(Random, enemyGrid)
        Else
            Set position = base.DestroyTarget(Random, enemyGrid, enemyGrid.FindHitArea)
        End If
    Loop Until base.IsLegalPosition(enemyGrid, position)
    Set IGameStrategy_Play = position
End Function
```

### FairPlayStrategy

Destroys enemy ships immediately upon location. Prevents ship adjacency during placement.

```vba
Private Sub IGameStrategy_PlaceShip(ByVal grid As PlayerGrid, ByVal currentShip As IShip)
    Do
        Dim direction As ShipOrientation
        Dim position As IGridCoord
        Set position = base.PlaceShip(Random, grid, currentShip, direction)
    Loop Until Not grid.HasAdjacentShip(position, direction, currentShip.Size)

    grid.AddShip Ship.Create(currentShip.ShipKind, direction, position)
    If grid.shipCount = PlayerGrid.ShipsPerGrid Then grid.Scramble
End Sub

Private Function IGameStrategy_Play(ByVal enemyGrid As PlayerGrid) As IGridCoord
    Dim position As GridCoord
    Do
        Dim area As Collection
        Set area = enemyGrid.FindHitArea

        If Not area Is Nothing Then
            Set position = base.DestroyTarget(Random, enemyGrid, area)
        Else
            Set position = base.ShootRandomPosition(Random, enemyGrid)
        End If
    Loop Until base.IsLegalPosition(enemyGrid, position)
    Set IGameStrategy_Play = position
End Function
```

### MercilessStrategy

Employs pattern shooting, targeting edges and center areas. Destroys ships immediately upon detection. Avoids areas too small for remaining ships. Includes randomized shooting with 10% probability.

```vba
Private Function IGameStrategy_Play(ByVal enemyGrid As PlayerGrid) As IGridCoord
    Dim position As GridCoord
    Do
        Dim area As Collection
        Set area = enemyGrid.FindHitArea

        If Not area Is Nothing Then
            Set position = base.DestroyTarget(Random, enemyGrid, area)
        Else
            If this.Random.NextSingle < 0.1 Then
                Set position = base.ShootRandomPosition(this.Random, enemyGrid)
            ElseIf this.Random.NextSingle < 0.6 Then
                Set position = ScanCenter(enemyGrid)
            Else
                Set position = ScanEdges(enemyGrid)
            End If
        End If
    Loop Until base.IsLegalPosition(enemyGrid, position) And _
               base.VerifyShipFits(enemyGrid, position, enemyGrid.SmallestShipSize) And _
               AvoidAdjacentHitPosition(enemyGrid, position)
    Set IGameStrategy_Play = position
End Function
```

The AI queries the enemy grid for "hit areas" rather than maintaining state, analyzing area orientation to determine optimal targeting.

Complete source code: [https://github.com/rubberduck-vba/Battleship](https://github.com/rubberduck-vba/Battleship)
