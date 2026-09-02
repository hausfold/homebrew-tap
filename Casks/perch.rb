cask "perch" do
  version "2026.08.31"
  sha256 "b519391a04e3e21527e171cecba823485b69aeffc46bc9c7c519baa0c9a76bd0"

  url "https://github.com/hausfold/perch/releases/download/v#{version}/perch-v#{version}-macos.zip"
  name "Perch"
  desc "Native macOS temporary file shelf that grows out of the MacBook notch"
  homepage "https://github.com/hausfold/perch"

  # The version/sha256 lines above are CI-owned: perch's release workflow
  # rewrites them on every date-versioned tag (hausfold/perch, release.yml) and
  # pushes here over a deploy key. Hand-edit only to bootstrap.
  #
  # Bootstrapping is over. CI has been writing those two lines since
  # v2026.08.03-1 (2026-08-03), so they are a real released zip's version and
  # hash, not the placeholders this comment used to warn about.
  livecheck do
    url :url
    strategy :github_latest
  end

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
