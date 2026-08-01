# priority: 1

# Install the Finder Quick Action (Automator) workflows into ~/Library/Services.
export def main [] {
  let quick_actions = "./files/quick-actions/"
  print "Copying macOS Quick Action Automator scripts..."

  for dir in (ls $quick_actions) {
    cp --recursive --verbose --update $dir.name $"($nu.home-dir)/Library/Services/"
  }
  print $"Successfully copied Automator scripts for Quick Actions ✅"
}
