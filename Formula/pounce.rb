class Pounce < Formula
  desc "Summon, aim, pounce - a native, scriptable command palette for macOS"
  homepage "https://github.com/nebelhaus/pounce"
  version "2026.07.27"
  url "https://github.com/nebelhaus/pounce/releases/download/v#{version}/pounce-v#{version}-macos.tar.gz"
  sha256 "140ded0f4edc901b54db108559fb0c22db10531dd468db0a3489b12537746d67"
  license "MIT"

  # The version/sha256 lines above are CI-owned: pounce's release workflow
  # rewrites them on every date-versioned tag (nebelhaus/pounce, release.yml) and
  # pushes here over a deploy key. Hand-edit only to bootstrap.
  livecheck do
    url :stable
    strategy :github_latest
  end

  # The release ships a prebuilt Pounce.app, signed with our Developer ID and
  # notarized — arm64 only, matching the nix aarch64-darwin target.
  depends_on arch: :arm64
  depends_on macos: :sonoma

  def install
    # Prebuilt bundle from the release tarball: Pounce.app is already signed with
    # our Developer ID and notarized (nebelhaus/pounce, release.yml). We only
    # place it and the command scripts — no compile step anymore.
    prefix.install "Pounce.app"
    bin.install_symlink prefix/"Pounce.app/Contents/MacOS/pounce"
    bin.install "ports"

    # The built-in command set, discovered by pounce-palette at runtime
    # (keg layout: <bin>/../share/pounce/commands is the script's default).
    (pkgshare/"commands").install Dir["commands/*.sh"]
    (pkgshare/"commands").install_symlink bin/"ports" => "ports.sh"
    bin.install "pounce-palette"

    # pounce-<id> wrappers, mirroring the Nix package (hotkey-friendly bins).
    Dir[pkgshare/"commands/*.sh"].map { |f| File.basename(f, ".sh") }.each do |id|
      (bin/"pounce-#{id}").write <<~SH
        #!/bin/bash
        export PATH="#{opt_bin}:$PATH"
        exec "#{opt_pkgshare}/commands/#{id}.sh" "$@"
      SH
      (bin/"pounce-#{id}").chmod 0555
    end

    # Homebrew's service DSL cannot currently emit AssociatedBundleIdentifiers,
    # so install the launch agent explicitly. That association makes macOS show
    # this background item as "Pounce"; without it, System Settings falls back
    # to the legal name on Pounce's Developer ID signing certificate.
    (prefix/"homebrew.mxcl.pounce.plist").write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>homebrew.mxcl.pounce</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/Pounce.app/Contents/MacOS/pounce</string>
          <string>--daemon</string>
        </array>
        <key>AssociatedBundleIdentifiers</key>
        <array>
          <string>com.local.pounce</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProcessType</key>
        <string>Interactive</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/pounce.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/pounce.log</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>LANG</key>
          <string>en_US.UTF-8</string>
        </dict>
        <key>LimitLoadToSessionType</key>
        <array>
          <string>Aqua</string>
          <string>Background</string>
          <string>LoginWindow</string>
          <string>StandardIO</string>
          <string>System</string>
        </array>
      </dict>
      </plist>
    PLIST
  end

  def caveats
    <<~EOS
      Start the palette daemon:
        brew services start pounce

      The daemon registers the hotkey itself - Cmd+Space by default. macOS
      gives Cmd+Space to Spotlight, so free it up first (System Settings ->
      Keyboard -> Keyboard Shortcuts -> Spotlight) or pick another combo in
      ~/.config/pounce/config.json ("hotkey"). Prefer an external hotkey tool
      (skhd, AeroSpace, ...)? Set hotkey.enabled to false there and bind your
      key to `pounce-palette` instead - but DON'T do both, or the external
      binding shadows the fast built-in hotkey and every summon spawns a client.

      Palette slow to open, or Cmd+Space does nothing? Run:
        pounce doctor
      It names whatever is shadowing the hotkey (a leftover skhd/AeroSpace
      binding, Spotlight, a missing grant) and how to fix it.

      Grant Accessibility (for clipboard auto-paste and emoji paste-back):
        pounce --request-accessibility
      The app is signed with a stable Developer ID, so this grant now persists
      across upgrades (it no longer has to be re-granted after each release).

      Your own commands go in ~/.config/pounce/commands - one self-describing
      shell script per command, no registry, no rebuild.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pounce --version")
  end
end
