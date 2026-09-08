{ ... }:

{
  # General > Keyboard > Keyboard Shortcuts > Modifier Keys.
  # But applied with hidutil rather than the per-device mapping System Settings writes,
  # so it covers external keyboards too.
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.defaults.NSGlobalDomain = {
    # Holding a key repeats it instead of opening the accent picker.
    ApplePressAndHoldEnabled = false;

    # Keyboard > "Keyboard navigation": Tab reaches text boxes and lists (2) rather
    # than buttons only (0).
    AppleKeyboardUIMode = 2;

    # Keyboard > Input Sources > Edit > "Correct spelling automatically".
    NSAutomaticSpellingCorrectionEnabled = false;
  };

  # Keyboard > the fn/globe key action (Press 🌐 key to): the key stays a plain modifier.
  system.defaults.hitoolbox.AppleFnUsageType = "Do Nothing";

  system.defaults.CustomUserPreferences.NSGlobalDomain = {
    # Suppress the input-source indicator bubble that flashes mid-screen after an idle
    # cursor or a language switch. No named nix-darwin option (nor Settings control),
    # hence the global domain escape hatch.
    TSMLanguageIndicatorEnabled = false;

    # WebKit reads its own autocorrect key, so both this and
    # NSAutomaticSpellingCorrectionEnabled above are set.
    WebAutomaticSpellingCorrectionEnabled = false;

    # Keyboard > Keyboard Shortcuts > Function Keys > "Use F1, F2, etc. keys as standard function keys".
    # The media functions move behind fn (e.g. fn + F2 = increase brightness, F2 alone is just F2).
    "com.apple.keyboard.fnState" = true;

    # Keyboard > Keyboard Shortcuts > App Shortcuts > All Applications.
    # `com.apple.custommenu.apps` is the list System Settings maintains of which apps
    # carry overrides; without NSGlobalDomain in it the equivalents below are ignored.
    "com.apple.custommenu.apps" = [ "NSGlobalDomain" ];
    NSUserKeyEquivalents = {
      # Ctrl-Opt-Return fills a window to the screen (the Window menu's "Fill").
      Fill = "~^↩";
    };
  };

  # NOTE: set these manually in Keyboard > Keyboard Shortcuts:
  #
  #   off  Screenshots > Cmd-Shift-3/4/5 and their Ctrl variants       (for Shottr)
  #   off  Spotlight > Cmd-Space, Opt-Cmd-Space                        (for Raycast)
  #   off  Mission Control > Cmd-Esc (Game Overlay)                    (for Raycast)
  #   off  Input Sources > Ctrl-Space, select previous input source
  #   on   Input Sources > Ctrl-Opt-Space, select next input source
}
