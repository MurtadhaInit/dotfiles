{ config, pkgs, ... }:

let
  # the Catppuccin themes repo for delta
  catppuccin-delta = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "delta";
    rev = "main";
    hash = "sha256-HHD0hszHIxf/tyQgS5KtdAN5m0EM9oI54cA2Ij1keOI=";
  };

  # the actual Delta theme file
  themes-file = "${catppuccin-delta}/catppuccin.gitconfig";
in
{
  # Git is installed globally with system packages
  home.packages = with pkgs; [
    delta
  ];

  xdg.configFile = {
    "git/config".source = ../../../../Applications/git/.config/git/config;
    "git/ignore".source = ../../../../Applications/git/.config/git/ignore;

    # Link the delta theme file
    # Note: the Bat Catppuccin theme is a prerequisite
    "git/delta/catppuccin.gitconfig".source = themes-file;
  };
}
