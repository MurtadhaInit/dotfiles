{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bottom
  ];

  xdg.configFile = {
    "bottom/bottom.toml".source = ../../../../Applications/bottom/.config/bottom/bottom.toml;
  };
}
