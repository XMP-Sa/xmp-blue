# Patch 0003 — Remove MTA branding from the product surface

**Date:** 2026-11-26
**Scope:** product identity (paths, registry, binaries, icons) — protocol untouched
**Upstream-sync risk:** medium (path literals across the client loader/core)

## Decision

XMP is its own platform, not an MTA skin. No user-visible surface may carry
the MTA name. What legally must stay (GPLv3 copyright notices in source
files and license texts) stays — that is attribution, not branding.

## Changes

| Area | Before | After |
|---|---|---|
| Registry root (HKLM) | `Software\Multi Theft Auto: San Andreas All` | `Software\XMP: San Andreas All` |
| ProgramData folder | `MTA San Andreas All` | `XMP San Andreas All` |
| Temp folder | `MTA<ver>` | `XMP<ver>` |
| Runtime folder next to exe | `MTA\` (core.dll, cgui.dll, locale…) | `XMP\` |
| Source data dir | `Shared/data/MTA San Andreas/MTA` | `Shared/data/XMP/XMP` |
| Proxy DLL in GTA folder | `mtasa.dll` | `xmp.dll` |
| Server binaries | `mta-server64`, `MTA Server.exe`, … | `xmp-server64`, `XMP Server.exe`, … |
| Client exe icons | MTA icon | XMP brand icon |
| Troubleshooter URL | help.multitheftauto.com | XMP-Launcher GitHub issues |
| Install detection probe | `MTA\core.dll` | `XMP\core.dll` |

Migration note: `CInstallManager` still reads the *old* `MTA San Andreas <ver>`
LocalAppData folder as a migration source, so settings from an old MTA
install can be imported on first run. That is intentional and invisible.

## Explicitly NOT changed

- **ASE gametype string `MTA:SA`** and the net protocol — wire compatibility
  with public servers. (Our own server browser does not display it.)
- **`netc.dll` / `core.dll` and other internal DLL names** — invisible to users.
- **Upstream NSIS installer scripts** (`Shared/installer/`) — XMP distributes
  through the XMP Launcher, never through the upstream installer.
- **Copyright headers in source files** — required by GPLv3.
- In-game main-menu artwork/text inside the game resources — tracked as
  patch 0004 (needs new art assets, not string edits).

## Verification

- `./utils/premake5 gmake` on the patched tree: exit 0.
- Windows client + Linux server compile on CI (XMP Build workflow).
- Runtime check pending first Windows smoke test: fresh install must create
  `ProgramData\XMP San Andreas All` and run from the `XMP\` runtime folder.
- Follow-up (Phase 2.5): XMP Launcher should pre-write the GTA path under
  the new registry root so the client never has to ask.
