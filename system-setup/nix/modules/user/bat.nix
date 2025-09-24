{ config, pkgs, ... }:

let
  # the Catppuccin themes repo for Bat
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "main";
    hash = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
  };

  # the actual Bat theme files
  themes-dir = "${catppuccin-bat}/themes/";
in
{
  home.packages = with pkgs; [
    bat
    bat-extras.core
  ];

  xdg.configFile = {
    "bat/config".source = ../../../../Applications/bat/.config/bat/config;

    # which is also $"(bat --config-dir)/themes"
    "bat/themes" = {
      source = themes-dir;
      onChange = "${pkgs.bat}/bin/bat cache --build";
    };
  };
}
