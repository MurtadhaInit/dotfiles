{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.helix;
in
{
  options.dotfiles.helix = {
    enable = lib.mkEnableOption "Enable Helix with dotfiles defaults";
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
        helix
      ]
    );

    xdg.configFile = {
      "helix/config.toml".source = ../../../Applications/helix/config.toml;
      "helix/languages.toml".source = ../../../Applications/helix/languages.toml;
    };
  };
}
