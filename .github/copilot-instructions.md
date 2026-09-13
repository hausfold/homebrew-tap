# Copilot instructions

**Read [`AGENTS.md`](../AGENTS.md) at the repo root first — it is the full,
authoritative instruction set for every agent working here, and this file is
only a pointer to it.** (Copilot doesn't follow file imports, hence the
duplication below; if the two ever disagree, `AGENTS.md` wins.)

The short version:

- This is the Homebrew tap for the [hausfold](https://github.com/hausfold)
  family: `Formula/scruff.rb`, `Formula/pounce.rb`, `Casks/perch.rb`.
- **This repo is CI-owned. Never hand-edit a `version`, `sha256`, `url` or
  `revision` line.** Each project's release workflow rewrites them here over a
  deploy key when its release tag lands. A hand-typed version is stale the next
  time CI runs; a hand-typed sha256 ships users a formula that refuses to
  install.
- **Which lines CI owns differs per entry.** pounce and perch own
  `version` + `sha256`, and their `url` is never touched, so a URL whose shape
  changed (a new owner) is a hand fix there. scruff owns `url` + `sha256` and
  has no `version` line at all — Homebrew reads the version out of the tag URL,
  and a second copy of it fails `brew audit`. Adding one back is a bug, not a
  tidy-up.
- Versions are **dates** (CalVer) for pounce and perch; **semver** for scruff.
  All of them are cut with `bench release <repo>` from the workshop and stamped
  in the *project's* repo. There is nothing to bump here.
- The **only** sanctioned hand-edit is bootstrapping a brand-new formula or cask,
  or changing the non-version parts: `desc`, `caveats`, `depends_on`, install
  logic.
- The two apps are already **Developer-ID signed and Apple-notarized** by CI, so
  no cask needs a quarantine workaround. Reaching for one means something
  upstream is unsigned, and that's the actual bug. scruff is a Go CLI that this
  tap compiles, and Homebrew never quarantines a formula's build, so there is
  nothing to sign there and no workaround to reach for either.
- `.github/workflows/check.yml` installs and tests `Formula/scruff.rb` alone,
  because it is the one entry that builds. pounce and perch are out of its
  scope by design.
- A bug in a tool is fixed in that tool's repo, never here.

For review comments: the highest-value check in this repo is **"would CI
overwrite this?"** If yes, say so — that matters more than style.
