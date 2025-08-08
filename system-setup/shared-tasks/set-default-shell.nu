# priority: 10

def set_default_shell [
  shell: string # the shell binary name (from `which...`)
  shell_name?: string # Optional: the name of this shell
] {
  let shell_name = (if ($shell_name | is-empty) { $shell | str capitalize } else { $shell_name })
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

set_default_shell "nu" "Nushell"