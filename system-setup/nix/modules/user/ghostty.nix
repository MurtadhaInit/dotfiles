{
  config,
  pkgs,
  lib,
  ...
}:

let
  # the Catppuccin themes repo for Ghostty
  catppuccin-ghostty = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "ghostty";
    rev = "main";
    hash = "sha256-4seUhPr6nv0ld9XMrQS4Ko9QnC1ZOEiRjENSfgHIvR0=";
  };

  # the actual Ghostty theme files
  themes-dir = "${catppuccin-ghostty}/themes/";
in
{
  home.packages = with pkgs; [
    ghostty
  ];

  xdg.configFile = {
    "ghostty/themes".source = themes-dir;
  };
}
