# priority: 1

def setup_quick_actions [quick_actions: string] {
  print "Copying macOS Quick Action Automator scripts..."

  for dir in (ls $quick_actions) {
    cp --recursive --verbose --update $dir.name $"($nu.home-path)/Library/Services/"
  }
  print $"Successfully copied Automator scripts for Quick Actions ✅"
}

setup_quick_actions "./files/quick-actions/"