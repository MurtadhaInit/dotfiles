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

export def ensure_repo [repo_url: string, repo_dest: string, flags?: list = []] {
  # TODO: support private repos by incorporating a credentials solution for SSH
  if (not ($repo_dest | path exists) or (ls $repo_dest | length) == 0) {
    git clone ...$flags $repo_url $repo_dest
    print $"Successfully cloned repo to ($repo_dest) ✅"
  } else {
    print $"Repo present: ($repo_dest) exists and is non-empty ✅"
  }
}