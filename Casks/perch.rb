cask "perch" do
  version "2026.07.29"
  sha256 "78e9d060e76066d13205946f4d0b60c3ee355a7753cb12e6bbf94a1788aa4aef"

  url "https://github.com/nebelhaus/perch/releases/download/v#{version}/perch-v#{version}-macos.zip"
  name "Perch"
  desc "Native macOS temporary file shelf that grows out of the MacBook notch"
  homepage "https://github.com/nebelhaus/perch"

  # The version/sha256 lines above are CI-owned: perch's release workflow
  # rewrites them on every date-versioned tag (nebelhaus/perch, release.yml) and
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

  # Perch is signed with our Developer ID and notarized by Apple (nebelhaus/perch,
  # release.yml), so Gatekeeper clears it on first launch — no quarantine hack.
end
