# nix-darwin mirrors system.defaults.trackpad into both the built-in trackpad domain
# and the Bluetooth (Magic Trackpad) one, so a single declaration covers either device.
{ ... }:

{
  system.defaults.trackpad = {
    # Half of Trackpad > Point & Click > "Look up & data detectors": this key only
    # says whether the three-finger tap variant is on. Which of the remaining two
    # states the dropdown shows ("Force Click with one finger" vs "Off") comes from
    # NSGlobalDomain's com.apple.trackpad.forceClick, left at its default of on.
    TrackpadThreeFingerTapGesture = 0;
  };

  # Trackpad > Point & Click and Trackpad > More Gestures.
  # Enable vertical-swipe gestures for Mission Control and App Exposé.
  # The finger count to trigger them comes from the Trackpad{Three,Four}FingerVertSwipeGesture
  # keys, both left at their defaults (i.e. 3 fingers).
  system.defaults.dock = {
    showMissionControlGestureEnabled = true;
    showAppExposeGestureEnabled = true;
  };
}
