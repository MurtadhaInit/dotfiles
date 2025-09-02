{
  config,
  pkgs,
  lib,
  ...
}:

let
  # the catppuccin themes repo for Nushell
  catppuccin-nushell = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "nushell";
    rev = "main";
    hash = "sha256-tQ3Br6PaLBUNIXY56nDjPkthzvgEsNzOp2gHDkZVQo0=";
  };

  # the theme flavour file in the repo
  mochaTheme = "${catppuccin-nushell}/themes/catppuccin_mocha.nu";
in
{
  programs.nushell = {
    enable = true;
    configFile.source = ../../../../Applications/nushell/.config/nushell/config.nu;

    # source the theme file
    extraConfig = ''
      source ${mochaTheme}
    '';
  };
}
