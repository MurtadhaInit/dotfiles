export def command_exists [cmd: string] {
  which $cmd | is-not-empty
}

export def ensure_homebrew_package [pkg: string, --cask] {
  let check_result = do { brew list $pkg } | complete
  if $check_result.exit_code != 0 {
    print $"Installing ($pkg)..."
    # TODO: incorporate a try catch block
    if $cask {
      brew install --cask --quiet $pkg
    } else {
      brew install --quiet $pkg
    }
  } else {
    print $"($pkg) is already installed ✅"
  }
}