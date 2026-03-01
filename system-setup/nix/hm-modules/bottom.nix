{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.bottom;
in
{
  options.dotfiles.bottom = {
    enable = lib.mkEnableOption "Enable Bottom with dotfiles defaults";
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
        bottom
      ]
    );

    xdg.configFile = {
      "bottom/bottom.toml".source = ../../../Applications/bottom/bottom.toml;
    };
  };
}
