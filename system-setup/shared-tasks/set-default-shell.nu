# priority: 10

# Set Nushell as the default interactive shell: add it to /etc/shells and chsh the user.
export def main [] {
  let shell = "nu" # the shell binary name (from `which...`)
  let shell_name = "Nushell" # the name of the shell
  print $"🔄 Setting ($shell_name) as the default interactive shell..."
  use ../utils/utils.nu [command_exists sudo_nu]

  if not (command_exists $shell) {
    print $"⚠️ ($shell_name) binary is not found. Install it and make it accessible in $path"
    exit 1
  }
  let shell_path = (which $shell | get path.0)

  if ($env.SHELL == $shell_path) {
    print $"✅ ($shell_name) is already the default shell for ($env.USER)"
  } else {
    # 1. Add it to /etc/shells
    if (open "/etc/shells" | str contains $shell_path) {
      print $"✅ ($shell_path) already included in /etc/shells"
    } else {
      try {
        with-env { SHELL_PATH: $shell_path } {
          sudo_nu --preserve-env-vars=[SHELL_PATH] { $env.SHELL_PATH | save --append "/etc/shells" } 
        }
        print $"✅ ($shell_path) added to /etc/shells"
      } catch {
        print $"⚠️ Failed to add ($shell_path) to /etc/shells"
        exit 1
      }
    }

    # 2. Change the default shell for this user
    try {
      with-env { SHELL_PATH: $shell_path } {
        sudo_nu --preserve-env-vars=[USER SHELL_PATH] { ^chsh -s $env.SHELL_PATH $env.USER }
      }
      print $"✅ Default shell successfully changed to ($shell_path) for ($env.USER)"
    } catch {
      print $"⚠️ Failed to change the default shell for ($env.USER)"
      exit 1
    }
  }
}
