{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable networking
  networking.networkmanager.enable = true;
}
