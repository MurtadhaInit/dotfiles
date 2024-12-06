print "Installing essential tools and applications with Homebrew..."

def install_essentials_with_homebrew [formulae_file: string, casks_file: string] {
  let formulae = open $formulae_file
      | lines
      | filter {|line|
          not ($line | str starts-with "#") and ($line | str trim) != ""
      }

  if ($formulae | is-empty) {
    print "No formulae found to install"
    return
  }

  print $'Installing: ($formulae | str join ", ")'
  try {
    for formula in $formulae {
      ensure_homebrew_package $formula
    }
    print $"Successfully installed ($formulae | length) formulae ✅"
  } catch {
    print "Failed to install some formulae ❗️"
    exit 1
  }
  
  let casks = open $casks_file
      | lines
      | filter {|line|
          not ($line | str starts-with "#") and ($line | str trim) != ""
      }

  if ($casks | is-empty) {
    print "No casks found to install"
    return
  }

  print $'Installing: ($casks | str join ", ")'
  try {
    for cask in $casks {
      ensure_homebrew_package $cask --cask
    }
    print $"Successfully installed ($casks | length) casks ✅"
  } catch {
    print "Failed to install some casks ❗️"
    exit 1
  }
}

install_essentials_with_homebrew "./files/homebrew_formulae.txt" "./files/homebrew_casks.txt"