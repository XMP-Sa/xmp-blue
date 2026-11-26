# Patch 0002 — Client executable branding (Phase 1)

**Date:** 2026-11-25
**Scope:** client launcher identity only — no protocol, no data-layout changes
**Upstream-sync risk:** low (one premake file, two loader units, resource files)

## What changed

The client launcher executable is now **XMP Client.exe**:

| File | Change |
|---|---|
| `Client/launch/premake5.lua` | `targetname` → `XMP Client`; resource file names updated |
| `Client/launch/Multi Theft Auto.rc/.h/.manifest`, `NEU/Multi Theft Auto.gdf.xml` | Renamed to `XMP Client.*`; GDF display name/description now XMP (upstream gameID kept) |
| `Client/launch/launch.rc` | Version info: CompanyName `XMP`, ProductName `XMP Client`, FileDescription `XMP Client Launcher`. **LegalCopyright left untouched** (upstream attribution, GPLv3/trademark hygiene) |
| `Client/launch/Main.cpp` | AppUserModelID → `XMP Client …` (taskbar identity) |
| `Client/launch/XMP Client.manifest` | assemblyIdentity name → `XMP Client` |
| `Client/loader/Main.h` | `MTA_EXE_NAME(_RELEASE)` → `XMP Client.exe` (`_d` in debug) |
| `Client/loader-proxy/main.cpp` | `MTA_EXE_NAME` constant → `XMP Client.exe` |
| `Client/loader/MainFunctions.cpp`, `CInstallManager.cpp`, `Install.cpp` | Hardcoded exe name in WER fallback + user-facing strings/comments updated |

Every code reference to the launcher exe name flows through these defines,
so the rename is consistent across the loader, proxy and install manager.

## Explicitly NOT changed (deliberate)

- **Data directories** (`MTA San Andreas` under AppData/ProgramData) and registry
  keys — renaming them is a user-data migration; it ships as patch 0003 together
  with the XMP Launcher's client manager, which can migrate existing installs.
- **DLL names** (`core.dll`, `mtasa.dll`, …) — internal, invisible to users.
- **Mutex GUID, net protocol, serial/client identification** — frozen (fork rule 1).
- **Server binary names** (`mta-server64` / `MTA Server.exe`) — hosting tooling
  expects them; server rename is evaluated separately in Phase 3.
- Upstream NSIS installer (`Shared/installer/`) — XMP ships through the XMP
  Launcher instead; the NSIS scripts stay as upstream reference.

## Verification

- `./utils/premake5 gmake` on the patched tree: **exit 0**, all projects
  generated (validates the premake edit + renamed resource files).
- Full compile of the client requires Windows + VS2026 → CI job
  `client-windows` in `.github/workflows/xmp-build.yml` (first run after the
  fork is pushed to GitHub). The Windows smoke test (connect to 3 public
  servers) remains the Phase 1 acceptance gate.
