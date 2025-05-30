# priority: 10

def setup_zsh [] {
  print "Setting up ZSH..."
  use ../utils/utils.nu ensure_homebrew_package
  ensure_homebrew_package "zsh"

  let homebrew_zsh_path = $"($env.HOMEBREW_PREFIX)/bin/zsh"
  if not ($homebrew_zsh_path | path exists) {
    print $"zsh is not found at ($homebrew_zsh_path). Install it and try again ❗️"
    exit 1
  }
  if ($env.SHELL == $homebrew_zsh_path) {
    print "zsh is already the default shell ✅"
  } else {
    sudo --preserve-env=HOMEBREW_PREFIX,USER,SHELL nu macos-tasks/privileged-tasks/make_homebrew_zsh_default_shell.nu
  }

  let target_line = 'export ZDOTDIR="$HOME/.config/zsh"'
  if (("/etc/zshenv" | path exists) and (open "/etc/zshenv" | str contains $target_line)) {
    print "Default location for zsh config files already switched ✅"
  } else {
    sudo --preserve-env=USER,HOME nu macos-tasks/privileged-tasks/switch_zsh_config_location.nu
  }
}

setup_zsh