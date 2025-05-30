# priority: 11

def symlink_dotfiles [] {
  use ../utils/utils.nu ensure_homebrew_package
  print "Symlinking dotfiles..."

  ensure_homebrew_package "stow"
  cd $"($nu.home-path)/.dotfiles/Applications"
  if not ($env.PWD | str ends-with ".dotfiles/Applications") {
    print "Couldn't navigate to the correct directory to symlink ❗️"
    exit 1
  }
  let dirs = ls | where type == dir | get name
  if ($dirs | is-empty) {
    print "No applications in .dotfiles/Applications to symlink ❗️"
    return
  }
  print $"Symlinking the following: ($dirs | str join ', ')"
  try {
    stow --restow ...$dirs
  } catch {
    print "Couldn't symlink dotfiles ❗️"
    exit 1
  }
}

symlink_dotfiles

# NOTE: the Applications directory needs to be 2 levels away
# from the home directory. Since GNU Stow does not support
# absolute paths due to a bug, the target directory is set
# to ../../ from the Applications directory.