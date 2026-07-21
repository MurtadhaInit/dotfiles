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
    rev = "main";
    hash = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
  };

  # the actual Bat theme files
  themes-dir = "${catppuccin-bat}/themes";
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
    };
  };
}
