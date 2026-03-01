{
  config,
  lib,
  ...
}:

let
  cfg = config.dotfiles.starship;
in
{
  options.dotfiles.starship = {
    enable = lib.mkEnableOption "Enable Starship with dotfiles defaults";
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the package via Nix (vs. just configure it)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = lib.mkIf cfg.installPackage true;
    };

    xdg.configFile = {
      "starship/starship.toml".source = ../../../Applications/starship/starship.toml;
    };
  };
}
