{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.starship = {
    enable = lib.mkDefault true;
  };

  xdg.configFile = {
    "starship/starship.toml".source = ../../../../Applications/starship/starship.toml;
  };
}
