# priority: 0

def setup_macos [] {
  print "Configuring macOS..."

  # Disable the annoying input source (language) switch bubble that pops up
  # after leaving the cursor idle for a while or when switching languages
  defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0
}

setup_macos