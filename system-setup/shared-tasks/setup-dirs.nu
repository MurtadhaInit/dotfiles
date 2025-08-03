# priority: 12

def setup_dirs [] {
  print "🔄 Creating directories..."

  let paths_to_create = [
    $"($nu.home-path)/Work"
    $"($nu.home-path)/Projects"
  ]

  mkdir --verbose ...$paths_to_create
  print $"✅ Successfully created directories:\n($paths_to_create | str join "\n")"
}

setup_dirs