# hausfold/tap

Homebrew tap for the [hausfold](https://github.com/hausfold) family.

```sh
brew tap hausfold/tap
brew install pounce           # formula (builds from source)
brew install --cask perch     # cask (prebuilt app)
```

> **Already on `nebelhaus/tap`?** It still works — GitHub redirects the clone —
> but Homebrew keys a tap by its directory, so you keep an old one until you
> say otherwise: `brew untap nebelhaus/tap && brew tap hausfold/tap`. Your
> installed pounce and perch are untouched by that.

| formula | what it is |
|---|---|
| [`pounce`](Formula/pounce.rb) | summon, aim, pounce — a native, scriptable command palette for macOS |

| cask | what it is |
|---|---|
| [`perch`](Casks/perch.rb) | a native macOS temporary file shelf that grows out of the MacBook notch |

Formulae build from source (a single `swiftc` against system frameworks — just
the Xcode Command Line Tools Homebrew already requires). Casks ship a prebuilt
`.app` from the project's GitHub release, signed with our Apple Developer ID and
notarized by Apple, so it opens straight away with no Gatekeeper prompt.

**This repo is CI-owned.** Version bumps are pushed by each project's release
workflow when a date-versioned `v<date>` tag lands (e.g. `v2026.07.18`; see
[pounce's `release.yml`](https://github.com/hausfold/pounce/blob/main/.github/workflows/release.yml));
humans only touch it to bootstrap a new formula or cask. Issues and PRs about
the *software* belong in the project repos.
