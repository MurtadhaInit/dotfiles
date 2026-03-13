{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.lazygit;
in
{
  options.dotfiles.lazygit = {
    enable = lib.mkEnableOption "Lazygit with dotfiles defaults";
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
        lazygit
      ]
    );

    # TODO: might switch to the standalone theme file from Catppuccin
    xdg.configFile = {
      "lazygit/config.yml".source = ../../../Applications/lazygit/config.yml;
    };
  };
}
