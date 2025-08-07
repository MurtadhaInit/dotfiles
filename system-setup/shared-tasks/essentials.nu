# priority: 9

def install_essentials_with_homebrew [] {
  use ../utils/utils.nu install_from_brewfile
  print "🔄 Installing essential tools and applications with Homebrew..."

  let brewfile = $"($nu.home-path)/.dotfiles/system-setup/files/Brewfile"
  install_from_brewfile $brewfile
}

install_essentials_with_homebrew