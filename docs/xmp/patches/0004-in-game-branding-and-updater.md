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
message boxes, crash-dump exe candidates, proxy launch warning, CEF user
agent and the core AppUserModelID now say **XMP / XMP Client**.
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

## Verification
- Windows client compiles on CI (XMP Build).
- Visual check pending the real-Windows smoke test: main menu shows the
  XMP logo; About/version watermark is the X glyph.
