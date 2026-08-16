cask "perch" do
  version "2026.08.16"
  sha256 "aba1280c7316285fddb53dd59dbd4cd88b153463b6a3298f929e59d978be21b4"

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
