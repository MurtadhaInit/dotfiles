# priority: 5

def clone_repos [] {
  use ../utils/utils.nu ensure_repo
  print "🔄 Cloning repos..."

  let repos = [
    { url: "https://github.com/MurtadhaInit/scripts.git" dest: $"($nu.home-path)/Scripts" }
  ]

  for repo in $repos {
    ensure_repo $repo.url $repo.dest
  }
}

clone_repos