print "Setting up ZSH..."

ensure_homebrew_package "zsh"

def make_homebrew_zsh_default_shell [] {
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
      print "Failed to add Homebrew-installed ZSH to /etc/shells ❗️"
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

make_homebrew_zsh_default_shell