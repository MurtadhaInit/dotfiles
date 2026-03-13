{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.jetbrains;
in
{
  options.dotfiles.jetbrains = {
    enable = lib.mkEnableOption "Jetbrains Toolbox with dotfiles defaults";
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
        jetbrains-toolbox
      ]
    );

    xdg.configFile = {
      "ideavim/ideavimrc".source = ../../../Applications/ideavim/ideavimrc;
    };
  };
}
