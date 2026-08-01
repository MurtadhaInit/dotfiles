# priority: 0

# Apply macOS system defaults (configurations).
export def main [] {
  print "Configuring macOS..."

  # Disable the annoying input source (language) switch bubble that pops up
  # after leaving the cursor idle for a while or when switching languages
  defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0
}
