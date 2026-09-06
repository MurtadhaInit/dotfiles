{ ... }:

{
  system.defaults.menuExtraClock = {
    ShowDate = 1; # 0 when space allows, 1 always, 2 never
    ShowDayOfWeek = true;
    ShowDayOfMonth = true;
    ShowAMPM = true;
  };

  # Control Center settings live in the per-host (ByHost) preference domain rather
  # than the plain one, which is why this is a separate option tree from the rest.
  system.defaults.controlcenter.BatteryShowPercentage = true;
}
