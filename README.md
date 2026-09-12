# hausfold/tap

The Homebrew tap for the [hausfold](https://github.com/hausfold) tools.

```sh
brew tap hausfold/tap

brew install scruff           # then: scruff skill install
brew install pounce           # then: brew services start pounce
brew install --cask perch
```

| | |
|---|---|
| [`scruff`](Formula/scruff.rb) | a lane per agent: park, resume, PR-verified reap |
| [`pounce`](Formula/pounce.rb) | summon, aim, pounce — a native, scriptable command palette |
| [`perch`](Casks/perch.rb) | a temporary file shelf that grows out of the MacBook notch |

The two apps arrive prebuilt from that project's GitHub release, signed with our
Developer ID and notarized by Apple, on Apple Silicon running macOS Sonoma or
newer. `scruff` is a single Go binary with nothing in it to sign, so it compiles
here instead, and it runs anywhere Homebrew does.

This repo holds the packaging metadata and nothing else. Every `sha256` in it is
written by release CI, along with whichever of `version` and `url` that entry
leaves to CI, never by hand ([the rule, in full](AGENTS.md)), so **bugs and
feature requests belong in the tool's own repo**: [scruff](https://github.com/hausfold/scruff),
[pounce](https://github.com/hausfold/pounce),
[perch](https://github.com/hausfold/perch).

---

<p align="center"><a href="https://hausfold.co">⌂ hausfold</a></p>
