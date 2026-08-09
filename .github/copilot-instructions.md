# Copilot instructions

**Read [`AGENTS.md`](../AGENTS.md) at the repo root first — it is the full,
authoritative instruction set for every agent working here, and this file is
only a pointer to it.** (Copilot doesn't follow file imports, hence the
duplication below; if the two ever disagree, `AGENTS.md` wins.)

The short version:

- This is the Homebrew tap for the [nebelhaus](https://github.com/nebelhaus)
  family: `Formula/pounce.rb`, `Casks/perch.rb`.
- **This repo is CI-owned. Never hand-edit a `version`, `url` or `sha256`
  line.** Each project's release workflow rewrites them here over a deploy key
  when a `v<date>` tag lands. A hand-typed version is stale the next time CI
  runs; a hand-typed sha256 ships users a formula that refuses to install.
- Versions are **dates** (CalVer), cut with `bench release <repo>` from the
  workshop, and stamped in the *project's* repo. There is nothing to bump here.
- The **only** sanctioned hand-edit is bootstrapping a brand-new formula or cask,
  or changing the non-version parts: `desc`, `caveats`, `depends_on`, install
  logic.
- Artifacts are already **Developer-ID signed and Apple-notarized** by CI, so no
  cask needs a quarantine workaround. Reaching for one means something upstream
  is unsigned, and that's the actual bug.
- A bug in a tool is fixed in that tool's repo, never here.

For review comments: the highest-value check in this repo is **"would CI
overwrite this?"** If yes, say so — that matters more than style.
