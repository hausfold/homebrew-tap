cask "trill" do
  version "2026.08.04-1"
  sha256 "f172851b5351586caa7155dcd5604b1683c423538a9bad59e1226248e6dbe989"

  url "https://github.com/nebelhaus/trill/releases/download/v#{version}/trill-v#{version}-macos.zip"
  name "Trill"
  desc "Native, provider-neutral macOS Messages client (iMessage/SMS/RCS)"
  homepage "https://github.com/nebelhaus/trill"

  # The version/sha256 lines above WERE CI-owned: trill's release workflow rewrote
  # them on every date-versioned tag (nebelhaus/trill, release.yml) and pushed here
  # over a deploy key. That repository is archived as of 2026-08-04, so nothing
  # writes this file automatically any more — 2026.08.04 is the last release, and
  # these lines are now hand-owned.
  livecheck do
    url :url
    strategy :github_latest
  end

  # Trill is finished, not broken: it reads and sends, and the features past that
  # need write access to chat.db or private automation Messages.app doesn't expose.
  # Deprecated rather than disabled on purpose — `brew install` and `brew upgrade`
  # keep working and only print a warning, so nobody's install breaks on our
  # decision to stop developing it.
  deprecate! date: "2026-08-04", because: "is no longer developed; its repository is archived"

  depends_on macos: :sonoma

  app "Trill.app"

  # Trill is signed with our Developer ID and notarized by Apple (nebelhaus/trill,
  # release.yml), so Gatekeeper clears it on first launch — no quarantine hack.

  caveats <<~EOS
    Trill is no longer developed — 2026.08.04 is the final release. It keeps
    working; there just won't be another. https://github.com/nebelhaus/trill

    The live Messages provider reads ~/Library/Messages/chat.db (always
    read-only) and needs Full Disk Access. Grant it once in System Settings ->
    Privacy & Security -> Full Disk Access (add Trill). Fixture mode needs
    no permissions at all.
  EOS
end
