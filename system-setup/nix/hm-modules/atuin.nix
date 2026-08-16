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
    rev = "68aa64b77573c235044b614e752a781701af4eec";
    hash = "sha256-4V9Rz37PlBLB1E3JVVYzrJwe9XXlKAFAO5gxWW/cTCw=";
  };

  # the actual Atuin theme files based on flavour
  # see https://github.com/catppuccin/atuin for other flavours
  themes-dir = "${catppuccin-atuin}/themes/mocha";
in
{
  options.dotfiles.atuin = {
    enable = lib.mkEnableOption "Atuin with dotfiles defaults";
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
