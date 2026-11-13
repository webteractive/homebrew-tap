# Written by scripts/release.sh in webteractive/yard: change packaging/yard.rb.tmpl there.
cask "yard" do
  version "0.1.0"
  sha256 "334a339e139c6ebc35e26c8022692e016b50ef8a40a5c2298a0e04dc9ff7c8cc"

  url "https://github.com/webteractive/yard/releases/download/v#{version}/Yard-#{version}-arm64.dmg"
  name "Yard"
  desc "Local PHP sites on macOS: the yard CLI, its daemon and Yard.app"
  homepage "https://github.com/webteractive/yard"

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "Yard.app"
  binary "#{appdir}/Yard.app/Contents/Helpers/yard"

  # brew runs uninstall on upgrade too, so nothing here stops yardd (every upgrade would
  # take every site down). After an install or upgrade, a loaded agent that runs this app's
  # yardd is restarted on the new build. Uninstalling Yard is `yard uninstall`.
  postflight do
    label = "gui/#{Process.uid}/dev.more.yard.daemon"
    info = `launchctl print #{label} 2>/dev/null`
    if $?.success? && info.include?("#{appdir}/Yard.app/Contents/Helpers/yardd")
      system "launchctl", "kickstart", "-k", label
    end
  end

  zap trash: [
    "~/Library/Preferences/dev.more.yard.app.plist",
    "~/Library/Caches/dev.more.yard.app",
  ]
end
