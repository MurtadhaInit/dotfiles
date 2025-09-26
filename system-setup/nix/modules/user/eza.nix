{ config, pkgs, ... }:

let
  # the Catppuccin themes repo for Eza
  catppuccin-nushell = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "eza";
    rev = "main";
    hash = "sha256-Q+C07IReQQBO5xYuFiFbS1wjmO4gdt/wIJWHNwIizSc=";
  };

  # the selected Eza theme file (flavour + accent)
  theme-file = "${catppuccin-nushell}/themes/mocha/catppuccin-mocha-mauve.yml";
in
{
  home.packages = with pkgs; [
    eza # also available as a flake
  ];

  xdg.configFile = {
    "eza/theme.yml".source = theme-file;
  };
}
