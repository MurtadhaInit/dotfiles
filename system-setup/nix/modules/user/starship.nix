{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
  };

  xdg.configFile = {
    "starship/starship.toml".source = ../../../../Applications/starship/.config/starship/starship.toml;
  };
}
