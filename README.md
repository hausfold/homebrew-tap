# hausfold/tap

The Homebrew tap for the [hausfold](https://github.com/hausfold) apps.
Apple Silicon, macOS Sonoma or newer.

```sh
brew tap hausfold/tap

brew install pounce           # then: brew services start pounce
brew install --cask perch
```

| | |
|---|---|
| [`pounce`](Formula/pounce.rb) | summon, aim, pounce — a native, scriptable command palette |
| [`perch`](Casks/perch.rb) | a temporary file shelf that grows out of the MacBook notch |

Both install a prebuilt `.app` from that project's GitHub release, signed with
our Apple Developer ID and notarized by Apple — so they launch on first
double-click, with no Gatekeeper prompt and no `xattr` incantation to paste.

**Bugs and feature requests belong in the app's own repo** —
[pounce](https://github.com/hausfold/pounce),
[perch](https://github.com/hausfold/perch). This repo holds nothing but
packaging metadata, and every `version`/`sha256` in it is written by each
project's release CI, never by hand
([the rule, in full](AGENTS.md)).

*Tapped `nebelhaus/tap` before the org move?* `brew untap nebelhaus/tap && brew
tap hausfold/tap` — Homebrew keys a tap by its directory, so the old one lingers
until you say otherwise. Your installed apps are untouched either way.

---

<p align="center"><a href="https://hausfold.co">⌂ hausfold</a></p>
