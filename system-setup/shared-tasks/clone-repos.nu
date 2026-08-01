# priority: 5

# Clone personal git repos.
export def main [] {
  use ../utils/utils.nu ensure_repo
  print "🔄 Cloning repos..."

  let repos = [
    { url: "https://github.com/MurtadhaInit/scripts.git" dest: $"($nu.home-dir)/Scripts" }
  ]

  for repo in $repos {
    ensure_repo $repo.url $repo.dest
  }
}
