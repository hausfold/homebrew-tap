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

Each entry installs a prebuilt `.app` from that project's GitHub release. This
repo holds nothing but the packaging metadata around it — every `version` and
`sha256` here is written by release CI, never by hand
([the rule, in full](AGENTS.md)) — so **bugs and feature requests belong in the
app's own repo**: [pounce](https://github.com/hausfold/pounce),
[perch](https://github.com/hausfold/perch).

---

<p align="center"><a href="https://hausfold.co">⌂ hausfold</a></p>
