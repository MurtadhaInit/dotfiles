{
  config,
  pkgs,
  lib,
  ...
}:

let
  # the Catppuccin themes repo for Nushell
  catppuccin-nushell = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "nushell";
    rev = "main";
    hash = "sha256-tQ3Br6PaLBUNIXY56nDjPkthzvgEsNzOp2gHDkZVQo0=";
  };

  # the actual Nushell theme files
  themes-dir = "${catppuccin-nushell}/themes/";
in
{
  programs.nushell = {
    enable = true;
    configFile.source = ../../../../Applications/nushell/Library
    + "/Application Support/nushell/config.nu";
  };

  xdg.configFile = {
    "nushell/themes".source = themes-dir;
  };
}
