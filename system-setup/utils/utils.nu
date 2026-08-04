export def command_exists [cmd: string] {
  which $cmd | is-not-empty
}

# Execute the provided closure in a sudo context
#
# Note: the newly created nu context won't carry over environment variables, jobs,
# and other things. E.g., you need to pass env vars explicitly with `--preserve-env-vars`
# Pass other variables to the closure using env vars instead and the aforementioned flag
export def sudo_nu [
  code: closure
  --preserve-env-vars: list<string> = [] # environment variables to be passed in (e.g. 'USER', 'SHELL')
] {
  let arg = (if ($preserve_env_vars | is-not-empty) {[('--preserve-env=' + ($preserve_env_vars | str join ','))]} else {[]})
  ^sudo ...$arg nu -c $"do (view source $code)"
}

# TODO: improve by spreading the pkg argument to allow for multiple packages
# Install the package `pkg` using Homebrew
export def ensure_homebrew_package [pkg: string, --cask] {
  const brew = (if $nu.os-info.name == "macos" {"/opt/homebrew/bin/brew"} else {"/home/linuxbrew/.linuxbrew/bin/brew"})
  if not (command_exists $brew) {
    print "⚠️ could not find 'brew' binary"
    return
  }

  let check_result = do { brew list $pkg } | complete
  if $check_result.exit_code != 0 {
    print $"🔄 Installing ($pkg)..."
    # TODO: incorporate a try catch block
    if $cask {
      brew install --cask --quiet $pkg
    } else {
      brew install --quiet $pkg
    }
  } else {
    print $"✅ ($pkg) is already installed"
  }
}

# Clone a git repository `repo_url` to the location `repo_dest`
export def ensure_repo [repo_url: string, repo_dest: string, flags?: list = []] {
  # TODO: support private repos by incorporating a credentials solution for SSH
  # TODO: check for the git binary
  if (not ($repo_dest | path exists) or (ls $repo_dest | length) == 0) {
    git clone ...$flags $repo_url $repo_dest
    print $"✅ Successfully cloned repo to ($repo_dest)"
  } else {
    print $"✅ Repo present: ($repo_dest) exists and is non-empty"
  }
}
