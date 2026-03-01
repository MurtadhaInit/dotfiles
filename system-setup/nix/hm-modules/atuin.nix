{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.atuin;

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
  options.dotfiles.atuin = {
    enable = lib.mkEnableOption "Enable Atuin with dotfiles defaults";
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the package via Nix (vs. just configure it)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.atuin = {
      enable = lib.mkIf cfg.installPackage true;
    };

    xdg.configFile = {
      "atuin/themes".source = themes-dir;
      "atuin/config.toml".source = ../../../Applications/atuin/config.toml;
    };
  };
}
