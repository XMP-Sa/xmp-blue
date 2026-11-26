# Patch 0001 — Branding defaults (Phase 1)

**Date:** 2026-11-25
**Scope:** data/config only — no C++ changes, no protocol impact
**Upstream-sync risk:** minimal (single-line changes in data files)

## Changes

| File | Change | Why |
|---|---|---|
| `Server/mods/deathmatch/mtaserver.conf` | Default `<servername>` → `XMP Server` | A fresh XMP Server announces itself as XMP in the master list instead of "Default MTA Server" |

## Explicitly NOT changed (yet)

- Binary names (`Multi Theft Auto.exe`, `MTA Server.exe`) — renaming the client
  launcher also means migrating the data directory name (`MTA San Andreas`),
  registry keys and the XMP Launcher's executable detection in one coordinated
  patch. Scheduled as patch 0002, after the first Windows smoke test.
- Window titles / in-client UI strings — same reason; they ride along with 0002.
- Net protocol version, serial/client identification, master-list endpoints —
  **frozen** for all of Phase 1 (see `XMP.md`, rule 1).

## Verification (2026-11-25, local sandbox build)

- Linux server build passes: `make config=release_x64 Core Launcher Deathmatch XML`
  → `Bin/server/mta-server64` + `x64/{core,deathmatch,xmll}.so` (exit 0).
  Note: the optional `dbconmy` module needs Oracle MySQL 8 headers (upstream's
  docker image has them; Debian/MariaDB headers do not), so it is excluded from
  the local sandbox build only. CI uses the official docker image and builds all.
- Server booted with the default config and answered an ASE query on
  `22003+123` exactly like an MTA server:
  `EYE1 · port 22003 · name "XMP Server" · MTA:SA · 1.7n · 0/32`
  → the existing XMP Launcher ping code sees XMP servers with zero changes.
