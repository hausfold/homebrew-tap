# AGENTS.md

**`hausfold/homebrew-tap`** — the Homebrew tap: `Formula/pounce.rb` (a prebuilt
`Pounce.app`) and `Casks/perch.rb` (a prebuilt `Perch.app`), placed, never
compiled. No tool bug is fixed here. Wiring:
[`.agents/`](./.agents/README.md).

## CI-owned

- **Never hand-edit a `version`, `sha256` or `revision` line** — each tool's
  `release.yml` rewrites them on a `v<date>` tag. Its `sed` touches nothing
  else, so a `url` or `homepage` whose shape changed is fixed by hand,
  never bumped.
- Versions are dates (`YYYY.MM.DD`, `-N` same day), stamped upstream by
  `bench release <repo>`; nothing here is bumped.
- **Hand-edit only to bootstrap a new formula or cask**, or for `desc`,
  `caveats`, `depends_on` and the install block.

## Routing

| Change… | Repo |
|---|---|
| a tool, or a bug in it | `pounce`, `perch` |
| a release — built, signed, notarized, or missing | that tool's `.github/workflows/release.yml` |
| how haus installs it | `haus` — `launcher` (pounce), `shelf` (perch) |

## Rules

- No quarantine workarounds: artifacts arrive signed and notarized, so
  an unsigned one is an upstream bug.
- `README.md` sends software issues upstream and indexes the tap; keep it in
  step.
- MIT, public. No identity, no secrets.
