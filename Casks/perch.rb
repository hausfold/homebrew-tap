cask "perch" do
  version "2026.09.11-1"
  sha256 "38e5a7ff8aeedeec2bcbf71f55d7b922c4adfbc5492e88d00d8997d99045a9fc"

  url "https://github.com/hausfold/perch/releases/download/v#{version}/perch-v#{version}-macos.zip"
  name "Perch"
  desc "Native macOS temporary file shelf that grows out of the MacBook notch"
  homepage "https://github.com/hausfold/perch"

  # The version/sha256 lines above are CI-owned: perch's release workflow
  # rewrites them on every date-versioned tag (hausfold/perch, release.yml) and
  # pushes here over a deploy key. Hand-edit only to bootstrap; the pair above
  # is a real released zip's version and hash, written by that workflow.
  livecheck do
    url :url
    strategy :github_latest
  end

  # Apple Silicon only. Every Perch.app the release workflow has published
  # carries an arm64 slice and no other, so without this line brew installs
  # the app onto an Intel Mac without a word and the first double-click is
  # macOS saying "not supported on this Mac" about a download that had no
  # business landing there. pounce's formula carries the same pair, in the
  # same order — `arch` before `macos` is what Homebrew's stanza-order cop
  # wants.
  #
  # The one way this line is wrong: Homebrew resolves it against
  # `Hardware::CPU.type`, which reports the TRANSLATED arch, so an M-series
  # Mac running a /usr/local Homebrew under Rosetta reports intel and is
  # refused here — for an app that would have run natively. The cask DSL has
  # no physical-CPU predicate, and refusing that layout is the cheaper of the
  # two mistakes: the other one ends in a dead app.
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Perch.app"

  # `perch` on PATH, as a SYMLINK into the bundle rather than a copy — the CLI
  # is signed and notarized *with* the app, so a copy would drift from the shelf
  # it talks to the first time either moved. This is the same link the flake
  # makes (hausfold/perch, nix/package.nix) and the same one haus's Shelf room
  # makes out of /Applications; a cask user had neither until now, so
  # `brew install --cask perch` left them with the app and no command, while
  # every other install route gave them both.
  #
  # ⚠️ The product is `perch-cli`, never `perch`, and that is load-bearing:
  # macOS filesystems are case-insensitive, so `Contents/MacOS/perch` IS
  # `Contents/MacOS/Perch` and would silently replace the app's own executable.
  # `target:` is what puts the friendly name on PATH without renaming anything
  # inside the bundle.
  binary "#{appdir}/Perch.app/Contents/MacOS/perch-cli", target: "perch"

  # The only place a cask can talk to a standalone user, so it's where
  # `perch skill install` gets named (workshop docs/agent-surface.md,
  # "Distribution"). Deliberately worded as optional: the verb exits 1 on a Mac
  # with no agent client at all, and a haus machine already has the skill from
  # haus.ai.skill. Not a CI-owned line - hand-edit this freely.
  caveats <<~EOS
    Optional - teach this Mac's coding agents about the shelf:
      perch skill install

    It writes perch's skill into every agent client it finds (Claude Code,
    Codex, OpenCode, pi) and refuses rather than overwrites what's already
    there.
  EOS

  # Perch is signed with our Developer ID and notarized by Apple (hausfold/perch,
  # release.yml), so Gatekeeper clears it on first launch — no quarantine hack.
end
