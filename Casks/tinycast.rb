cask "tinycast" do
  # `version` and `sha256` are bumped automatically by the tinycast release workflow
  # (stable channel). Placeholder until the first stable release is cut.
  version "0.11.4"
  sha256 "2add3724d3cb0a0928d18b8ce8ce2422c6c54364dc22352521dccd6d3a2012de"

  url "https://github.com/aang-dev-ag/tinycast/releases/download/v#{version}/Tinycast-#{version}.dmg"
  name "Tinycast"
  desc "Tiny, fully native launcher, hotkeys, and clipboard history"
  homepage "https://github.com/aang-dev-ag/tinycast"

  # `:golden_gate` already means ">= macOS 27".
  depends_on macos: :golden_gate
  # This DMG is arm64-only; macOS 27 runs on Apple silicon alone.
  depends_on arch: :arm64

  app "Tinycast.app"

  # Tinycast is signed with a stable self-signed identity (not an Apple Developer ID / not
  # notarized), so macOS quarantines it. Strip the flag on every install AND upgrade so
  # Gatekeeper won't block launch — the user never has to run xattr by hand.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Tinycast.app"]
  end

  # Quit the running app before Homebrew replaces the bundle on upgrade/uninstall — otherwise
  # the update clobbers a live process.
  uninstall quit: "com.tinycast.app"

  zap login_item: "Tinycast",
      trash:      [
        "~/Library/Application Support/com.tinycast.app",
        "~/Library/Caches/com.tinycast.app",
        "~/Library/Preferences/com.tinycast.app.plist",
        "~/Library/Saved Application State/com.tinycast.app.savedState",
      ]
end
