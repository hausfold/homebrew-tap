cask "perch" do
  version "2026.08.20-1"
  sha256 "8a5aabcea5c19ee054b5dfc55abcf5af56a72b2b989738fc83b6623c336d4320"

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

  # Perch is signed with our Developer ID and notarized by Apple (hausfold/perch,
  # release.yml), so Gatekeeper clears it on first launch — no quarantine hack.
end
