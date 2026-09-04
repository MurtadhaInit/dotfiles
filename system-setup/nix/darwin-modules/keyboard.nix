{ ... }:

{
  # Suppress the input-source indicator bubble that flashes mid-screen after an idle
  # cursor or a language switch.
  # No named nix-darwin option covers this key hence the global domain escape hatch.
  system.defaults.CustomUserPreferences.NSGlobalDomain.TSMLanguageIndicatorEnabled = false;
}
