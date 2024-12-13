export const order = 9

def brewfile_installation [] {
  use ../utils/utils.nu ensure_homebrew_package
  print "Installing/upgrading everything from Brewfile (including App Store apps)..."

  ensure_homebrew_package "mas"
  with-env { HOMEBREW_CASK_OPTS: "--no-quarantine" } {
    cd $"($nu.home-path)/.dotfiles/Homebrew"
    let check = do { brew bundle check --verbose --no-upgrade --file=./Brewfile } | complete
    if ($check.exit_code != 0) {
      brew bundle install --no-upgrade --verbose --cleanup --file=./Brewfile
    } else {
      print $check.stdout
    }
    # print "Initiating Homebrew cleanup..."
    # brew cleanup --verbose --prune=all
  }
}

brewfile_installation