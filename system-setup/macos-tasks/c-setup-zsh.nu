export const order = 2

def make_homebrew_zsh_default_shell [] {
  use ../utils/utils.nu ensure_homebrew_package
  print "Setting up ZSH..."

  ensure_homebrew_package "zsh"
  let homebrew_zsh_path = $"($env.HOMEBREW_PREFIX)/bin/zsh"

  if not ($homebrew_zsh_path | path exists) {
    print $"zsh is not found at ($homebrew_zsh_path). Install it and try again ❗️"
    exit 1
  }

  if ($env.SHELL == $homebrew_zsh_path) {
    print "zsh is already the default shell ✅"
    return
  }

  let shells_file = "/etc/shells"
  if not (open $shells_file | str contains $homebrew_zsh_path) {
    try {
      # TODO: test. might require extra permissions
      $homebrew_zsh_path | save --append $shells_file
    } catch {
      print $"Failed to add ($homebrew_zsh_path) to /etc/shells file ❗️"
      exit 1
    }
  }

  try {
      # TODO: test. might require extra permissions
      chsh -s $homebrew_zsh_path
      print $"Current default shell successfully changed to ($homebrew_zsh_path) ✅"
      print $"Current shell is ($env.SHELL)"
  } catch {
      print "Failed to change the default shell ❗️"
      exit 1
  }
}

# This needs to happen only after zsh dotfiles have been correctly symlinked
def change_default_zsh_config_location [] {
  use ../utils/utils.nu ensure_homebrew_package
  print "Changing the default location of zsh configuration files..."

  let zsh_config_dir = $"($nu.home-path)/.config/zsh"
  if not (($zsh_config_dir | path exists) and (ls $zsh_config_dir | length) > 0 and ($zsh_config_dir | path type) == "symlink") {
    print "zsh related config files have not been correctly symlinked ❗️"
    exit 1
  }
  
  let target_line = 'export ZDOTDIR="$HOME/.config/zsh"'
  
  if not ("/etc/zshenv" | path exists) {
    print "/etc/zshenv does not exist. Creating file..."
    # TODO: check if the file exists by default
    # sudo touch "/etc/zshenv"
    # sudo chown root:root "/etc/zshenv"
    # sudo chmod 644 "/etc/zshenv"
    # The file needs to be owned by root and has the permissions rw r r
    # See which step needs to happen first: the permission change or content addition
  } else {
    print $"/etc/zshenv exists ✅"
  }

  if (open "/etc/zshenv" | str contains $target_line) {
    print "Default zsh config location already set ✅"
    return
  }
  
  $target_line | save --append "/etc/zshenv"
}

make_homebrew_zsh_default_shell
change_default_zsh_config_location