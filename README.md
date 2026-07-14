# 4-in-1 ESC

4-in-1 brushless ESC for FPV drones. 40×40mm, 6-layer PCB. 3–8S LiPo (11–33.6V), 60A continuous / 120A burst per motor. STM32G071 + AM32 open-source firmware, DShot/Oneshot/PWM input, KISS telemetry. Sponsored by PCBWay.

---

## Specifications

| Parameter | Value |
|-----------|-------|
| Input voltage | 3–8S LiPo (11–33.6V) |
| Continuous current | 60A per motor |
| Burst current | 120A per motor |
| PCB size | 40mm × 40mm |
| PCB layers | 6 |
| MCU | STM32G071GBU6 × 4 (one per motor) |
| Firmware | AM32 (open-source) |
| MOSFETs | Infineon BSC070N10NS3G (100V, 7mΩ) |
| Gate driver | JSM6288Q half-bridge |
| Power regulator | TI LMR51610 buck (→10V) + TI TLV76733 LDO (→3.3V) |
| Protocols | DShot150/300/600, Oneshot125/42, Multishot, PWM |
| Telemetry | KISS / AM32 ESC telemetry (RPM, current, voltage, temperature) |
| Sensing | Per-motor current, battery voltage, temperature |

---

## Design Highlights

- **Power tree:** LMR51610 wide-VIN synchronous buck (up to 33.6V → 10V, 56µH) feeds a TLV76733 LDO for the 3.3V MCU/logic rail.
- **MOSFETs:** 100V-rated Infineon BSC070N10NS3G with input capacitors derated to ~50% effective capacitance at DC bias.
- **Gate drive:** JSM6288Q bootstrap half-bridge drivers with per-phase RC snubbers.
- **Sensing:** Bidirectional current sensing on each motor phase for telemetry and RPM feedback via DShot.
- **Firmware:** AM32 timer-based protocol auto-detection covers DShot150/300/600, Oneshot, Multishot, and standard PWM.

---

## Repository Layout

| File / Folder | Contents |
|---------------|----------|
| `4-in-1_ESC.kicad_pro` | KiCad project file |
| `4-in-1_ESC.kicad_sch` | Top-level schematic |
| `BLDCDrive.kicad_sch` | BLDC motor drive sub-sheet |
| `DCDC.kicad_sch` | Power supply sub-sheet |
| `STM_MCU.kicad_sch` | STM32G071 MCU sub-sheet |
| `I_V_SENSE.kicad_sch` | Current / voltage sensing sub-sheet |
| `4-in-1_ESC.kicad_pcb` | PCB layout |
| `libs/` | Symbols, footprints, 3D models (LCSC imports) |
| `add-lcsc-part.ps1` | Script to add LCSC components via easyeda2kicad |

---

## Adding LCSC Components

Run from the repo root:

```powershell
.\add-lcsc-part.ps1 -LcscId C529347
```

Requires `pip install easyeda2kicad`. The script downloads the symbol, footprint, and 3D model, fixes all paths to use `${KIPRJMOD}` (portable), and registers the libraries automatically.

---

*Sponsored by [PCBWay](https://www.pcbway.com)*
