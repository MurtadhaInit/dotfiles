# System-wide look and feel
{ ... }:

{
  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";

    # Permanent scrollbars rather than the overlay ones that fade out: scroll position
    # stays readable without touching the trackpad.
    AppleShowScrollBars = "Always";

    # Finder/open-panel sidebar icons: 1 small, 2 medium, 3 large.
    NSTableViewDefaultSizeMode = 2;

    AppleShowAllExtensions = true;
  };

  system.defaults.CustomUserPreferences.NSGlobalDomain = {
    # Green accent (0 red, 1 orange, 2 yellow, 3 green, 4 blue, 5 purple, 6 pink;
    # absent means multicolour). The highlight string is the literal "r g b <name>"
    # System Settings writes, and the trailing name is what the picker shows as
    # selected, so it has to match the components.
    AppleAccentColor = 3;
    AppleHighlightColor = "0.847059 0.847059 0.862745 Graphite";

    # Double-clicking a title bar fills the window to the screen edge instead of
    # zooming or minimising.
    AppleActionOnDoubleClick = "Fill";
    AppleMiniaturizeOnDoubleClick = false;

    # Quitting an app leaves its windows to be restored on next launch, and closing a
    # document always asks about unsaved changes rather than silently keeping them.
    NSQuitAlwaysKeepsWindows = true;
    NSCloseAlwaysConfirmsChanges = true;
  };
}
