# This needs to happen only after zsh dotfiles have been correctly symlinked
def change_default_zsh_config_location [] {
  print "Changing the default location for zsh configuration files..."

  let zsh_config_dir = $"($nu.home-path)/.config/zsh"
  if not (($zsh_config_dir | path exists) and (ls $zsh_config_dir | length) > 0 and ($zsh_config_dir | path type) == "symlink") {
    print "zsh config files have not been correctly symlinked ❗️"
    exit 1
  }

  if not ("/etc/zshenv" | path exists) {
    print "/etc/zshenv does not exist. Creating file..."
    # this file does not exist by default
    touch "/etc/zshenv"
    # The file needs to be owned by root and to have the permissions rw r r
    chown root:wheel "/etc/zshenv"
    chmod 644 "/etc/zshenv"
    # See which step needs to happen first: the permission change or content addition
  } else {
    print "/etc/zshenv exists ✅"
  }

  let target_line = 'export ZDOTDIR="$HOME/.config/zsh"'
  if not (open "/etc/zshenv" | str contains $target_line) {
    try {
      $target_line | save --append "/etc/zshenv"
      print "Successfully amended /etc/zshenv ✅"
    } catch {
      print "Failed to append to /etc/zshenv ❗️"
      exit 1
    }
  }
}

change_default_zsh_config_location