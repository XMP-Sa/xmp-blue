# XMP — fork of mtasa-blue

This repository is **XMP Blue**, a fork of [multitheftauto/mtasa-blue](https://github.com/multitheftauto/mtasa-blue)
(the open-source Multi Theft Auto: San Andreas engine, GPLv3).

XMP turns that engine into an independent, XMP-branded multiplayer platform:

- **Phase 1 (current):** protocol-identical fork. XMP Client connects to existing
  public MTA servers; XMP Server registers like any MTA server. Only branding and
  defaults differ from upstream.
- **Later phases:** the XMP Launcher manages this client (download/update/launch),
  and XMP-operated servers join the same client. See `docs/xmp/ROADMAP.md` in the
  `xmp-launcher` repository.

## Rules of this fork

1. **Never touch the net protocol or client identification in Phase 1.** Any change
   there disconnects XMP from public MTA servers.
2. **Keep every XMP change small, isolated and documented** in `docs/xmp/patches/`
   so upstream merges stay cheap.
3. **Upstream copyright and GPLv3 notices stay intact.** XMP is a modified version
   of MTA and is marked as such, as GPLv3 requires.
4. GTA San Andreas game files are **never** distributed. Users provide their own
   legally obtained copy.

## Branches

| Branch | Purpose |
|---|---|
| `master` | Mirror of upstream `multitheftauto/mtasa-blue` — do not commit here |
| `xmp/main` | XMP working branch (upstream merges land here) |

## Upstream sync

```bash
git remote add upstream https://github.com/multitheftauto/mtasa-blue.git
git fetch upstream
git checkout xmp/main
git merge upstream/master   # resolve, smoke-test, then release
```

Sync cadence: monthly, or on each stable upstream release.

## Building

Unchanged from upstream — see the upstream `README.md`:

- **Windows client:** Visual Studio 2026 + DirectX SDK → `win-create-projects.bat`,
  build `Build/MTASA.sln` (Release, Win32), then `win-install-data.bat`
- **Linux server:** `./linux-build.sh --arch=x64 --config=release`

CI: `.github/workflows/xmp-build.yml` produces `XMP-Client-win32` and
`XMP-Server-linux-x64` artifacts on every push to `xmp/main`.

## License

GPLv3 — see `LICENSE`. This is a modified version of Multi Theft Auto;
it is not affiliated with or endorsed by the MTA team or Rockstar.
