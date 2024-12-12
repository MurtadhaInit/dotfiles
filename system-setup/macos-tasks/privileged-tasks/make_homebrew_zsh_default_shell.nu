def make_homebrew_zsh_default_shell [] {
  print "Making Homebrew-installed ZSH the default shell..."
  let homebrew_zsh_path = $"($env.HOMEBREW_PREFIX)/bin/zsh"
  let shells_file = "/etc/shells"

  if (open $shells_file | str contains $homebrew_zsh_path) {
    print $"($homebrew_zsh_path) is already included in /etc/shells file ✅"
  } else {
    try {
      $homebrew_zsh_path | save --append $shells_file
      print $"($homebrew_zsh_path) added to /etc/shells file ✅"
    } catch {
      print $"Failed to add ($homebrew_zsh_path) to /etc/shells file ❗️"
      exit 1
    }
  }

  try {
      chsh -s $homebrew_zsh_path $env.USER
      print $"Default shell successfully changed to ($homebrew_zsh_path) for ($env.USER) ✅"
      # TODO: to test in a fresh system install:
      # the next line probably won't be useful since a new session is required to reflect change
      # print $"Current shell is ($env.SHELL)"
  } catch {
      print $"Failed to change the default shell for ($env.USER) ❗️"
      exit 1
  }
}

make_homebrew_zsh_default_shell