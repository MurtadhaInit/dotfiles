{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.bat;

  # the Catppuccin themes repo for Bat
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
    hash = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
  };

  # the actual Bat theme files
  themes-dir = "${catppuccin-bat}/themes";

  # bat has no built-in Nushell syntax (sharkdp/bat#2129)
  nushell-syntax = pkgs.fetchFromGitHub {
    owner = "kurokirasama";
    repo = "nushell_sublime_syntax";
    rev = "8a1bb9205859d0c2f362c6c5a2b7ef1a7a87c387";
    hash = "sha256-2A7c6/FOsOyzyGAshZJZvZ/m5w1cKj7uckB+pzdlr3M=";
  };
in
{
  options.dotfiles.bat = {
    enable = lib.mkEnableOption "Bat with dotfiles defaults";
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the package via Nix (vs. just configure it)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf cfg.installPackage (
      with pkgs;
      [
        bat
        bat-extras.core
      ]
    );

    xdg.configFile = {
      "bat/config".source = ../../../Applications/bat/config;

      # which is also $"(bat --config-dir)/themes"
      "bat/themes" = {
        source = themes-dir;
        onChange = "${pkgs.bat}/bin/bat cache --build";
      };

      "bat/syntaxes/nushell.sublime-syntax" = {
        source = "${nushell-syntax}/nushell.sublime-syntax";
        onChange = "${pkgs.bat}/bin/bat cache --build";
      };
    };
  };
}
