# priority: 1

# Install every CLI tool, GUI app, and App Store app from the Brewfile.
export def main [] {
  const brew = "/opt/homebrew/bin/brew"
  if not ($brew | path exists) {
    print "⚠️ could not find 'brew' binary — install Homebrew first"
    return
  }

  # App Store apps are installed via `mas` (itself already in the Brewfile), which
  # requires you to be signed in to the App Store first (otherwise those entries fail).
  input "⚠️  Sign in to the App Store first, then press Enter to continue... "

  print "🔄 Installing everything from the Brewfile (including App Store apps)..."
  ^$brew bundle install --no-upgrade --file=$"($nu.home-dir)/.dotfiles/Homebrew/Brewfile"
  print "✅ done!"
}
