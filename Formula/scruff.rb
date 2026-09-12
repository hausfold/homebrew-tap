class Scruff < Formula
  desc "Worktree lifecycle for parallel coding agents: park, resume, PR-verified reap"
  homepage "https://github.com/hausfold/scruff"
  url "https://github.com/hausfold/scruff/archive/refs/tags/v1.3.61.tar.gz"
  sha256 "d11667891f418bb200683699ec5721c4670e497025847eeeaa4cea7dbbf68c53"
  license "MIT"
  head "https://github.com/hausfold/scruff.git", branch: "main"

  # The url/sha256 pair above is CI-owned: scruff's release workflow rewrites
  # both on every `v<semver>` tag (hausfold/scruff, release.yml) and pushes here
  # over a deploy key. Hand-edit only to bootstrap.
  #
  # This is the ONE entry in the tap whose CI-owned lines are `url` + `sha256`
  # rather than `version` + `sha256`. There is no `version` line on purpose:
  # Homebrew scans the version out of a tag URL by itself, and declaring it
  # again is a `brew audit` failure ("redundant with version scanned from URL").
  # pounce and perch can hold the line because their URLs interpolate it out of
  # an artifact filename Homebrew cannot parse.
  livecheck do
    url :stable
    strategy :github_latest
  end

  # scruff is one pure-Go binary with no cgo, so unlike pounce and perch there is
  # nothing here to sign, notarize or restrict to an architecture: it builds and
  # runs anywhere Homebrew does, Intel and Linux included.
  depends_on "go" => :build

  def install
    # The tap's other two entries place a prebuilt, notarized .app. This one
    # compiles, and that is a deliberate difference rather than an oversight:
    # a CLI installed by `brew` is never quarantined, so a Developer ID
    # signature would buy nothing, and the alternative — attaching four
    # cross-compiled binaries to every release — is machinery to keep true for
    # a build that takes seconds.
    #
    # `-X …commands.Version` is the same stamp the Makefile and the flake apply
    # (hausfold/scruff, Makefile and flake.nix). Without it `scruff --version`
    # reports the `0.1.0-dev` default baked into internal/commands/root.go, and
    # the test below is what keeps that honest.
    ldflags = "-s -w -X github.com/hausfold/scruff/internal/commands.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/scruff"
  end

  def caveats
    <<~EOS
      Optional - teach this Mac's coding agents that lanes exist:
        scruff skill install

      Without it an agent reaches for `git worktree add` and `git stash`, which
      is the one footgun scruff exists to close. It writes scruff's skills into
      every agent client it finds and refuses rather than overwrites.

      `git` is the hard requirement and you have it. `gh` and `lsof` are
      optional and both make scruff sharper: gh proves a branch landed across
      squash and rebase merges, lsof proves nobody is standing in a checkout.
      Without either one scruff degrades toward keeping a lane, never toward
      deleting one.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scruff --version")

    # "An empty list is a working install" (hausfold.co/docs/scruff/install).
    # Run from outside any repo against Homebrew's throwaway HOME, this walks
    # the real path — read the registry, find no lanes, say so — while needing
    # no git remote, no forge auth and no agent client.
    #
    # The exit code is deliberately not asserted. scruff answers 3 for
    # "degraded: a signal I wanted was missing", and whether a runner has `gh`
    # and `lsof` on it is not this formula's claim to make. A binary that
    # failed to run prints no header either way, which is the thing being
    # tested.
    assert_match "lanes you can resume", shell_output("#{bin}/scruff 2>&1 || true")
  end
end
