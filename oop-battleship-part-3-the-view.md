---
id: 0E73-B42E-7B0D-4CAC-BA48-A18C-E254-2338
name: oop-battleship-part-3-the-view
title: "OOP Battleship Part 3: The View"
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
url: https://rubberduckvba.blog/2018/09/04/oop-battleship-part-3-the-view/
created_at: 2025-11-19T08:43:08
---
# OOP Battleship Part 3: The View

## View Architecture

The view component makes game state visible and handles bidirectional controller communication. Excel worksheets provide the presentation layer with conditional formatting mapping to `GridState` enum values:

- Unknown = -1
- PreviewShipPosition = 0
- ShipPosition = 1
- InvalidPosition = 2
- PreviousMiss = 3
- PreviousHit = 4

The `PlayerGrid.StateArray` property returns a 2D variant array with `Unknown` as `Empty`. Refreshing the view requires dumping this array onto the appropriate grid range:

```vba
Private Property Get PlayerGrid(ByVal gridId As Byte) As Range
    Set PlayerGrid = Me.Names("PlayerGrid" & gridId).RefersToRange
End Property

Public Sub RefreshGrid(ByVal grid As PlayerGrid)
    Application.ScreenUpdating = False
    Me.Unprotect
    PlayerGrid(grid.gridId).Value = Application.WorksheetFunction.Transpose(grid.StateArray)
    Me.Protect
    Me.EnableSelection = xlUnlockedCells
    Application.ScreenUpdating = True
End Sub
```

## Event Handling

The worksheet handles three events that relay messages to the controller:

```vba
Private Sub Worksheet_BeforeDoubleClick(ByVal target As Range, ByRef Cancel As Boolean)
    Cancel = True
    Dim gridId As Byte
    Dim position As IGridCoord
    Set position = RangeToGridCoord(target, gridId)
    If Mode = FleetPosition Or Mode = player1 And gridId = 2 Or Mode = player2 And gridId = 1 Then
        RaiseEvent DoubleClick(gridId, position, Mode)
    End If
End Sub

Private Sub Worksheet_BeforeRightClick(ByVal target As Range, Cancel As Boolean)
    Cancel = True
    If Mode = FleetPosition Then
        Dim gridId As Byte
        Dim position As IGridCoord
        Set position = RangeToGridCoord(target, gridId)
        RaiseEvent RightClick(gridId, position, Mode)
    End If
End Sub

Private Sub Worksheet_SelectionChange(ByVal target As Range)
    Dim gridId As Byte
    Dim position As IGridCoord
    Set position = RangeToGridCoord(target, gridId)
    If Not position Is Nothing Then
        Me.Unprotect
        CurrentSelectionGrid(gridId).Value = position.ToA1String
        CurrentSelectionGrid(IIf(gridId = 1, 2, 1)).Value = Empty
        Me.Protect
        Me.EnableSelection = xlUnlockedCells
        RaiseEvent SelectionChange(gridId, position, Mode)
    End If
End Sub
```

Document modules cannot safely implement interfaces. A separate `WorksheetView` class handles view interfaces, communicating with the worksheet indirectly.

## Interface Separation

Two interfaces enable bidirectional communication:

- `IGridViewCommands`: Controller-to-view messages
- `IGridViewEvents`: View-to-controller messages

The `WorksheetView` class implements `IGridViewCommands`:

```vba
Private Sub IGridViewCommands_OnBeginAttack(ByVal currentPlayerGridId As Byte)
    sheetUI.ShowInfoBeginAttackPhase currentPlayerGridId
End Sub

Private Sub IGridViewCommands_OnBeginShipPosition(ByVal currentShip As IShip, ByVal player As IPlayer)
    sheetUI.ShowInfoBeginDeployShip currentShip.Name
End Sub

Private Sub IGridViewCommands_OnBeginWaitForComputerPlayer()
    Application.Cursor = xlWait
    Application.StatusBar = "Please wait..."
End Sub
```

The `WorksheetView` handles worksheet events:

```vba
Private Sub sheetUI_DoubleClick(ByVal gridId As Byte, ByVal position As IGridCoord, ByVal Mode As ViewMode)
    Select Case Mode
        Case ViewMode.FleetPosition
            ViewEvents.ConfirmShipPosition gridId, position
        Case ViewMode.player1, ViewMode.player2
            ViewEvents.AttackPosition gridId, position
    End Select
End Sub

Private Sub sheetUI_SelectionChange(ByVal gridId As Byte, ByVal position As IGridCoord, ByVal Mode As ViewMode)
    If Mode = FleetPosition Then ViewEvents.PreviewShipPosition gridId, position
End Sub
```

## Adapter Pattern

VBA interfaces cannot expose events. The `GridViewAdapter` class implements both `IGridViewEvents` and `IGridViewCommands`, bridging the gap. The `WorksheetView` references the adapter through `IGridViewEvents`:

```vba
Private Sub IGridViewEvents_AttackPosition(ByVal gridId As Byte, ByVal position As IGridCoord)
    RaiseEvent OnAttackPosition(gridId, position)
End Sub

Private Sub IGridViewEvents_ConfirmShipPosition(ByVal gridId As Byte, ByVal position As IGridCoord)
    RaiseEvent OnConfirmCurrentShipPosition(gridId, position)
End Sub

Private Sub IGridViewEvents_HumanPlayerReady()
    RaiseEvent OnPlayerReady
End Sub
```

The `GameController` contains `Private WithEvents viewAdapter As GridViewAdapter`, enabling event handling without worksheet knowledge.

## Decoupling and Flexibility

The controller knows only the `GridViewAdapter`, not the worksheet or `WorksheetView`. Initialization demonstrates this decoupling:

```vba
Public Sub PlayWorksheetInterface()
    Dim view As WorksheetView
    Set view = New WorksheetView

    Dim randomizer As IRandomizer
    Set randomizer = New GameRandomizer

    Set controller = New GameController
    controller.NewGame GridViewAdapter.Create(view), randomizer
End Sub
```

The adapter works with any `IGridViewCommands` implementation. Alternative views require only interface implementation:

```vba
Public Sub PlayUserFormInterface()
    Dim view As UserFormView
    Set view = New UserFormView

    Dim randomizer As IRandomizer
    Set randomizer = New GameRandomizer

    Set controller = New GameController
    controller.NewGame GridViewAdapter.Create(view), randomizer
End Sub
```

The same game executes with entirely different UI through polymorphic view substitution.
