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

export def ensure_repo [repo_url: string, repo_dest: string] {
  # TODO: support private repos by incorporating a credentials solution for SSH
  # TODO: add a flag to recursively add submodules too and use this function whenever a repo needs to be cloned
  if (not ($repo_dest | path exists) or (ls $repo_dest | length) == 0) {
    git clone https://github.com/catppuccin/bat.git $repo_dest
    print $"Successfully cloned repo to ($repo_dest) ✅"
  } else {
    print $"($repo_dest) exists and is non-empty \(repo cloned\) ✅"
  }
}