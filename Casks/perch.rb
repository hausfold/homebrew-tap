cask "perch" do
  version "2026.08.08-2"
  sha256 "b34f3b36e82e13eb0c0dd1b7d78ff04c482045ed0aeaf034f4e60a8486c19249"

  url "https://github.com/hausfold/perch/releases/download/v#{version}/perch-v#{version}-macos.zip"
  name "Perch"
  desc "Native macOS temporary file shelf that grows out of the MacBook notch"
  homepage "https://github.com/hausfold/perch"

  # The version/sha256 lines above are CI-owned: perch's release workflow
  # rewrites them on every date-versioned tag (hausfold/perch, release.yml) and
  # pushes here over a deploy key. Hand-edit only to bootstrap.
  #
  # BOOTSTRAP: perch has not been released yet, so version + sha256 are
  # placeholders (the release URL 404s until then). The first `bench release
  # perch` stamps a real v<date> tag; CI's bump-tap sed replaces both quoted
  # lines with the released zip's version + hash.
  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Perch.app"

  # Perch is signed with our Developer ID and notarized by Apple (hausfold/perch,
  # release.yml), so Gatekeeper clears it on first launch — no quarantine hack.
end
