# priority: 9

def install_essentials_with_homebrew [formulae_file: string, casks_file: string] {
  use ../utils/utils.nu ensure_homebrew_package
  print "Installing essential tools and applications with Homebrew..."

  let formulae = open $formulae_file
      | lines
      | filter {|line|
          not ($line | str starts-with "#") and ($line | str trim) != ""
      }

  let casks = open $casks_file
      | lines
      | filter {|line|
          not ($line | str starts-with "#") and ($line | str trim) != ""
      }

  if (($formulae | append $casks) | is-empty) {
    print "No formulae or casks found to install"
    return
  }

  with-env { HOMEBREW_CASK_OPTS: "--no-quarantine", HOMEBREW_NO_INSTALL_UPGRADE: "1" } {
    if not ($formulae | is-empty) {
      print $'Installing formulae: ($formulae | str join ", ")'
      try {
        brew install --quiet ...$formulae
        print $"Successfully installed ($formulae | length) formulae ✅"
      } catch {
        print "Failed to install some formulae ❗️"
      }
    }

    if not ($casks | is-empty) {
      print $'Installing casks: ($casks | str join ", ")'
      try {
        brew install --quiet --cask ...$casks
        print $"Successfully installed ($casks | length) casks ✅"
      } catch {
        print "Failed to install some casks ❗️"
      }
    }
  }
}

install_essentials_with_homebrew "./files/homebrew_formulae.txt" "./files/homebrew_casks.txt"