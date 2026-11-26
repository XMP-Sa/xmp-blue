# Patch 0004 — In-game branding + neutralized self-updater

**Date:** 2026-11-26
**Scope:** main-menu artwork, user-facing strings, update endpoints
**Upstream-sync risk:** low–medium (strings + 2 images + 1 header)

## Changes

### Artwork (same file names — zero layout/imageset churn)
| File | Change |
|---|---|
| `Shared/data/XMP/XMP/cgui/images/background_logo.png` | MTA logo replaced with XMP artwork: brand mark + ember glow + "XMP / SAN ANDREAS MULTIPLAYER" (generated from `assets/branding` vectors, Sora typeface) |
| `Shared/data/XMP/XMP/cgui/images/version.png` | white MTA watermark glyph → white XMP X glyph |

`background.png` (screenshot collage) intentionally kept: it is unbranded
game imagery.

### User-facing strings
"Multi Theft Auto" product strings in the loader splash, install manager
and privilege-elevation message boxes, crash-dump exe candidates, proxy
launch warning, CEF user agent, tray tooltip, credits heading/window,
version string and the core AppUserModelID now say **XMP / XMP Client**.
The legacy LocalAppData path used only as a read-only migration source is
intentionally unchanged.
The same treatment covers the in-game settings labels, game window title,
crash dialogs, loader dialogs, local-server defaults and the XMP Server
console header. The local-server launcher now looks for `XMP Server64.exe`
(matching Patch 0003's server target names). Localization loads from
`XMP/locale/`, and the process-base-dir walk accepts an `XMP` runtime
folder as well as the legacy one.
Translation templates (`locale/*.po`) still contain the old msgids; they
fall back to the new English strings until the next Crowdin sync.

### Self-updater neutralized (important)
The in-client version updater pointed at `updatesa.multitheftauto.com` /
`updatesa.mtasa.com` (16 endpoints incl. update, report, crash-dump and
news). Left alone, an XMP Client could "update" itself back into a stock
MTA build and would keep sending crash reports to MTA. All endpoints now
point at `https://updates.invalid/` (RFC 2606 — guaranteed unroutable):
checks fail fast and silently, nothing leaves the machine.
**Client updates are owned by the XMP Launcher** (manifest + SHA-256),
which is the single update channel. News button now opens the XMP
Launcher repo instead of multitheftauto.com/news.

### Kept on purpose
- ASE master-list endpoints used by the in-game server browser
  (functional dependency for public-server compatibility, not branding).
- Internal identifiers (`MTA_*` macros, class names) — invisible to users,
  renaming them would make upstream merges unmaintainable.
- The HTTP user-agent sent to game servers and the legacy LocalAppData
  migration source path — server-facing identification / migration plumbing,
  not product branding.

## Verification
- Windows client compiles on CI (XMP Build).
- Visual check pending the real-Windows smoke test: main menu shows the
  XMP logo; About/version watermark is the X glyph.
