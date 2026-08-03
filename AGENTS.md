# AGENTS.md

**`nebelhaus/homebrew-tap`** — the Homebrew tap for the
[nebelhaus](https://github.com/nebelhaus) family: `Formula/pounce.rb` (builds
from a signed release tarball) and `Casks/trill.rb` / `Casks/perch.rb` (prebuilt,
notarized `.app`s).

**This file is the one set of instructions, for every agent.** Claude Code,
Codex, OpenCode, Cursor, Copilot — TUI or GUI — all read *this*, directly or
through a one-line pointer. Nothing harness-specific belongs here; when a flow
needs per-client wiring, the wiring lives in that client's own file and the
*content* stays here or in `.agents/`. The map of which tool reads which file is
[`.agents/README.md`](./.agents/README.md).

## The one rule: this repo is CI-owned

**Do not hand-edit a `version`, `url` or `sha256` line. Ever.** Each project's
release workflow rewrites them here over a deploy key when a date-versioned
`v<date>` tag lands — pounce's `release.yml`, trill's, perch's. A hand-typed
version is wrong the moment CI runs again, and a hand-typed sha256 ships users a
formula that refuses to install.

The version is a **date** (CalVer, `YYYY.MM.DD`, `-N` on a same-day repeat), cut
with `bench release <repo>` from the workshop. There is nothing to "bump" — the
date IS the version, and it is stamped in the project's repo, not here.

**The only sanctioned hand-edit is bootstrapping a brand-new formula or cask**
(a new tool's first release, before CI has ever written its file), or fixing the
non-version parts: `desc`, `caveats`, `depends_on`, the install block's logic.
Even then, leave the CI-owned lines exactly as they are.

## Am I in the right repo? (routing)

**This repo owns PACKAGING METADATA ONLY** — how Homebrew places an already-built
artifact. It never builds a tool from its sources, and no bug in a tool is fixed
here.

| Want to change… | Repo |
|---|---|
| a formula/cask's install logic, caveats or dependencies | here ← **you are here** |
| what a tool does, or a bug in it | that tool's repo (`pounce`, `trill`, `perch`) |
| how a release is built, signed and notarized | that tool's `.github/workflows/release.yml` |
| how the rice installs a tool (the flake path, not brew) | `nebelhaus` → `modules/<tool>` |
| the version of anything | nowhere by hand — `bench release <repo>` from the workshop |

> **Whatever agent you are, enforce this.** "Just bump the version so it
> installs" is the single most tempting wrong edit in this repo. If a release
> looks missing or stale, the fix is in the project's release workflow, not in a
> hand-written line here.

## Conventions

- **Formulae build from source; casks ship a prebuilt `.app`.** Both artifacts
  are already Developer-ID signed and Apple-notarized by CI, so no cask needs a
  quarantine workaround — if you find yourself reaching for one, something
  upstream is unsigned and *that's* the bug.
- Issues and PRs about the *software* belong in the project repos; this repo's
  README says so and should keep saying so.
- Keep `README.md`'s formula/cask tables in step when a tool is added or
  retired — it's the only human-written index of what this tap carries.
- MIT, public. No identity, no secrets.
