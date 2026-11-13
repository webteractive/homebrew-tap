# Written by scripts/release.sh in webteractive/yard: change packaging/yard.rb.tmpl there.
cask "yard" do
  version "0.1.4"
  sha256 "3913ef4bc6c22a0f9496bb67e5cc46404e7fc912cdcaec8cd819b94e6da7d6c3"

  url "https://github.com/webteractive/yard/releases/download/v#{version}/Yard-#{version}-arm64.dmg"
  name "Yard"
  desc "Local PHP sites: the yard CLI, its daemon and Yard.app"
  homepage "https://github.com/webteractive/yard"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Yard.app"
  binary "#{appdir}/Yard.app/Contents/Helpers/yard"

  # brew runs uninstall on upgrade too, so nothing here stops yardd (every upgrade would
  # take every site down). After an install or upgrade, a loaded agent that runs an installed
  # Yard.app's yardd (not a dev build's) is restarted on the new build. Uninstalling Yard is
  # `yard uninstall`.
  postflight_steps do
    run "/bin/sh",
        args:         [
          "-c",
          'label="gui/$(id -u)/dev.more.yard.daemon"; ' \
          'if launchctl print "$label" 2>/dev/null | grep -qE "program = .*/Yard\.app/Contents/Helpers/yardd$"; ' \
          'then launchctl kickstart -k "$label"; fi',
        ],
        must_succeed: false
  end

  zap trash: [
    "~/Library/Caches/dev.more.yard.app",
    "~/Library/Preferences/dev.more.yard.app.plist",
  ]
end
