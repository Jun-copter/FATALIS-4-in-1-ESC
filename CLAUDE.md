# 4-in-1 ESC

KiCad project files live at the repo root.

## Adding LCSC components

Run from the repo root:

```powershell
.\add-lcsc-part.ps1 -LcscId C529347
```

The script downloads symbol + footprint + 3D model via `easyeda2kicad`, fixes the 3D model path to use `${KIPRJMOD}` (portable), and creates `sym-lib-table` / `fp-lib-table` if missing. No manual steps needed.

Requires: `pip install easyeda2kicad`

## Library layout

All LCSC imports share one set of library files inside `libs/`:

| Path | Contains |
|------|----------|
| `libs/easyeda_import.kicad_sym` | Symbols |
| `libs/easyeda_import.pretty/` | Footprints (`.kicad_mod`) |
| `libs/easyeda_import.3dshapes/` | 3D models (`.wrl`, `.step`) |

Libraries are registered project-locally via `sym-lib-table` and `fp-lib-table` using `${KIPRJMOD}` paths — the project is portable.

## Link chain

Symbol → Footprint: `easyeda_import:<footprint_name>` (set in symbol's Footprint property)
Footprint → 3D model: `${KIPRJMOD}/libs/easyeda_import.3dshapes/<model>.wrl`
