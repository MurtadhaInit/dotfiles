{
  config,
  pkgs,
  lib,
  ...
}:

let
  # the Catppuccin themes repo for Atuin
  catppuccin-atuin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "atuin";
    rev = "main";
    hash = "sha256-t/Pq+hlCcdSigtk5uzw3n7p5ey0oH/D5S8GO/0wlpKA=";
  };

  # the actual Atuin theme files based on flavour
  # see https://github.com/catppuccin/atuin for other flavours
  themes-dir = "${catppuccin-atuin}/themes/mocha";
in
{
  programs.atuin = {
    enable = lib.mkDefault true;
  };

  xdg.configFile = {
    "atuin/themes".source = themes-dir;
    "atuin/config.toml".source = ../../../../Applications/atuin/config.toml;
  };
}
