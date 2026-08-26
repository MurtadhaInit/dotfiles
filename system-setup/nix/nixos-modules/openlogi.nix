{ inputs, ... }:

{
  # nixpkgs' openlogi is darwin-only (and lags upstream), so Linux takes the
  # package and its NixOS module from the project's own flake. The module is
  # what registers the udev rules HID++ access needs - a bare package install
  # leaves the Bolt receiver unreadable.
  imports = [
    inputs.openlogi.nixosModules.default
  ];

  programs.openlogi = {
    enable = true;
    launchAtLogin = true; # agent binds to graphical-session.target
  };
}
