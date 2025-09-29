# Dynamic Battle Planner (Godot 4.4)

Touch-friendly isometric battle planner used to prototype hive layouts, assign keeps, and plan
reinforcements. Supports small (2x2) and large (3x3) keeps, grid snapping, overlap detection,
arrow lines with troop-type icons, and JSON save/load of the map.

## Key Features
- Isometric grid with **snap-to-grid** placement
- **Drag & drop** keeps (desktop + mobile long-press)
- **2x2** and **3x3** keep sizes (per-player toggle)
- **Popup menu** on keep (mobile-friendly) with:
  - Create reinforcement arrow → choose troop type
  - Delete keep
  - (Optional) Change arrow icon
- Reinforcement **arrows**: each keep can send to exactly one target; targets can receive multiple
- **Overlap detection** with visual highlight
- **Save/Load** map to JSON (players, keeps, arrows)
- (Optional) Top-down / isometric view toggle (kept non-blocking to working isometric logic)

## Controls
**Desktop**
- Click + drag: move keep (snaps to grid)
- Right click (or double-click): open keep popup menu
- ESC: cancel placement / popup

**Mobile**
- Long-press: pick up keep
- Release: place (snaps to grid)
- Double-tap: open keep popup menu (safest universal gesture)

## Tech / Project Notes
- Engine: **Godot 4.4**
- Scenes: `Keep.tscn` (2x2/3x3), `ReinforcementArrow.tscn`, `GridOverlay.tscn`
- Scripts: `Keep.gd`, `KeepFactory.gd`, `GridOverlay.gd`, `Main.gd`, `Settings.gd`
- Data: `save/map.json` (players, keeps, arrows, troop types)
- Known good: **isometric mode** is the canonical view; top-down is optional and shouldn’t alter placement logic

## Screenshots
<img width="1152" height="648" alt="shot-2025-09-28T222412" src="https://github.com/user-attachments/assets/57738e97-ad1c-4638-bef9-8264ff717357" />



## Save File (JSON) – Example
```json
{
  "created": "2025-09-28T22:24:04",
  "keeps": [
    {
      "cell_size": [
        64,
        32
      ],
      "color": {
        "a": 0.25,
        "b": 0.463207334280014,
        "g": 0.463207334280014,
        "r": 0.87890625
      },
      "footprint": [
        2,
        2
      ],
      "grid": [
        9,
        11
      ],
      "name": "Player1",
      "size": 2
    },
    {
      "cell_size": [
        64,
        32
      ],
      "color": {
        "a": 0.25,
        "b": 0.463207334280014,
        "g": 0.667809188365936,
        "r": 0.87890625
      },
      "footprint": [
        2,
        2
      ],
      "grid": [
        9,
        8
      ],
      "name": "Player2",
      "size": 2
    },
    {
      "cell_size": [
        64,
        32
      ],
      "color": {
        "a": 0.25,
        "b": 0.0336254350841045,
        "g": 0.95703125,
        "r": 0.105766534805298
      },
      "footprint": [
        3,
        3
      ],
      "grid": [
        13,
        12
      ],
      "name": "Building1",
      "size": 3
    },
    {
      "cell_size": [
        64,
        32
      ],
      "color": {
        "a": 0.25,
        "b": 0.91015625,
        "g": 0.543595492839813,
        "r": 0.199250429868698
      },
      "footprint": [
        2,
        2
      ],
      "grid": [
        8,
        19
      ],
      "name": "Player4",
      "size": 2
    },
  "version": "1.0"
}
