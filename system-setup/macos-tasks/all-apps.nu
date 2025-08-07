# priority: 1

def install_everything [] {
  use ../utils/utils.nu [ensure_homebrew_package install_from_brewfile]
  print "🔄 Installing everything from Brewfile (including App Store apps)..."

  ensure_homebrew_package "mas"
  # TODO: pause here to make sure the user is logged-in to the app store
  let brewfile = $"($nu.home-path)/.dotfiles/Homebrew/Brewfile"

  install_from_brewfile $brewfile --just-those
}

install_everything