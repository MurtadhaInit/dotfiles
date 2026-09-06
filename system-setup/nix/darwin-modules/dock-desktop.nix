# The Dock is declared in full: `persistent-apps` and `persistent-others` replace the
# whole tile list on every activation, so anything dragged in by hand is dropped on the
# next rebuild. Add it here instead.
{ ... }:

{
  system.defaults.dock = {
    autohide = true;
    autohide-delay = 0.0; # no dwell before it slides out (there is no UI equivalent)
    orientation = "right";

    tilesize = 23;
    magnification = true;
    largesize = 58;

    mineffect = "scale";
    mru-spaces = false; # keep Spaces in a fixed order instead of rearranging based on most recent
    show-recents = false;
    expose-group-apps = true; # Mission Control groups windows by app

    # Finder and the bin are also there by default on either ends
    persistent-apps = [ { app = "/System/Applications/Utilities/Activity Monitor.app"; } ];

    persistent-others = [
      {
        folder = {
          path = "/Users/murtadha/Downloads";
          arrangement = "date-added";
          displayas = "stack";
          showas = "grid";
        };
      }
    ];

    # Hot corners: 1 disabled, 2 Mission Control, 4 Desktop.
    wvous-tl-corner = 1;
    wvous-tr-corner = 2;
    wvous-br-corner = 4;
  };
}
