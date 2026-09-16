# AGENTS.md

**`hausfold/homebrew-tap`** — the Homebrew tap: `Formula/pounce.rb` (a prebuilt
`Pounce.app`) and `Casks/perch.rb` (a prebuilt `Perch.app`), placed, never
compiled — plus `Formula/scruff.rb`, the one entry that **does** compile, a Go
build of the CLI from its tag tarball. No tool bug is fixed here. Wiring:
[`.agents/`](./.agents/README.md).

## CI-owned

- **Never hand-edit a `version`, `sha256`, `url` or `revision` line that CI
  owns for that entry** — each tool's `release.yml` rewrites its own on the
  release tag. The `sed` touches nothing else, so a `homepage`, or a `url` CI
  does *not* own (pounce's and perch's, which interpolate `#{version}`), whose
  shape changed is fixed by hand, never bumped.
- Which lines that is differs by entry, and the difference is load-bearing:
  pounce and perch own `version` + `sha256`, because their URLs interpolate the
  version out of an artifact filename Homebrew cannot parse. **scruff owns
  `url` + `sha256` and carries no `version` line at all** — Homebrew scans the
  version out of a tag URL by itself, and declaring it a second time is a
  `brew audit` failure.
- Versions are dates (`YYYY.MM.DD`, `-N` same day) for pounce and perch,
  stamped upstream by `bench release <repo>`; scruff is the family's one semver
  repo. Nothing here is bumped either way.
- **Hand-edit only to bootstrap a new formula or cask**, or for `desc`,
  `caveats`, `depends_on` and the install block.

## The gate

`.github/workflows/check.yml` runs `brew style`, `brew audit --online`,
`brew install --build-from-source` and `brew test` — **over
`Formula/scruff.rb` alone**, on a macOS runner. It exists because that entry
both compiles and is rewritten by a bot, and it **gates** that rewrite:

- scruff's release pushes its new `url`/`sha256` to **`bump/scruff-v<version>`**,
  never to `main`.
- `check` runs on that branch.
- Green, and the `promote` job fast-forwards `main` and deletes the branch.
  Red, and `main` keeps the previous formula — users install a release-old
  `scruff` that works, instead of a current one that doesn't.

So a bump branch still standing means **a release whose formula didn't land**:
its run is red or cancelled, `main` is on the previous tag, and a release cut
hours ago whose `brew install` still fetches the old tag is this, not a slow
CDN. (A branch left beside a *green* run is the harmless case — the promote
warned that it could not delete it, and the next release force-pushes over it.)

To recover: fix the formula, then **Re-run failed jobs** on that `check` run.
Not "re-run `promote`" — it is `needs: formula`, so a red gate leaves it
*skipped*, and a skipped job cannot be re-run alone. Pushing the formula to
`main` by hand is never the answer; it is the exact thing the gate is here to
stop.

**pounce and perch push straight to `main` as before, and should.** The gate
never reads their entries, so routing them through a branch would gate nothing
and cost each release the wait; their own release workflows already built,
signed and notarized what those entries place.

That is also why `main` has **no push trigger at all** any more. The bot that
needed one stopped pushing there; promote's own push cannot re-trigger a
workflow; and what is left landing on `main` is pounce's and perch's near-daily
bumps, which would otherwise spend a macOS runner rebuilding a formula they did
not touch. A hand-edit to `main` — which the CI-owned rules above allow only to
bootstrap an entry — is checked by running `check` from the Actions tab. The
workshop's
[`docs/ci.md`](https://github.com/hausfold/workshop/blob/main/docs/ci.md) is the
family's rules; this gate follows them.

## Routing

| Change… | Repo |
|---|---|
| a tool, or a bug in it | `scruff`, `pounce`, `perch` |
| a release — built, signed, notarized, or missing | that tool's `.github/workflows/release.yml` |
| how haus installs it | `haus` — `launcher` (pounce), `shelf` (perch), the AI room (scruff) |

## Rules

- No quarantine workarounds: the apps arrive signed and notarized, so an
  unsigned one is an upstream bug. A formula-installed CLI is never quarantined
  at all, which is why scruff's binary is not signed and does not need to be.
- `README.md` sends software issues upstream and indexes the tap; keep it in
  step.
- MIT, public. No identity, no secrets.
