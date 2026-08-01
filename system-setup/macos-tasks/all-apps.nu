# priority: 1

# Install every CLI tool, GUI app, and App Store app from the Brewfile
# (also removes anything installed that isn't listed).
# Sign in to the App Store first.
export def main [] {
  use ../utils/utils.nu [ensure_homebrew_package install_from_brewfile]
  print "🔄 Installing everything from Brewfile (including App Store apps)..."

  ensure_homebrew_package "mas"
  # TODO: pause here to make sure the user is logged-in to the app store
  let brewfile = $"($nu.home-dir)/.dotfiles/Homebrew/Brewfile"

  install_from_brewfile $brewfile --just-those
}
