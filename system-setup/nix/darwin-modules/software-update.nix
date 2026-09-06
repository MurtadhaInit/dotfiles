# System updates install themselves; App Store apps do not.
{ ... }:

{
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

  # No named option covers the App Store's own auto-update switch, and it lives in a
  # system-wide domain rather than the user's.
  system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.commerce".AutoUpdate = false;
}
