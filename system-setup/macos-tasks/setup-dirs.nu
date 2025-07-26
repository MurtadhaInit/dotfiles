# priority: 12

def setup_dirs [] {
  print "Creating directories..."

  let paths_to_create = [
    $"($nu.home-path)/Work"
    $"($nu.home-path)/Projects"
  ]
  mkdir --verbose ...$paths_to_create
  print $"Successfully created directories: ($paths_to_create | str join ' ') ✅"
}

setup_dirs