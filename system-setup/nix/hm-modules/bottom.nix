{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.bottom;
in
{
  options = {
    programs.bottom = {
      installPackage = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install the bottom package via Nix.
          Set to false if you want to use bottom installed through other means (e.g., Homebrew)
          while still managing the configuration through Home Manager.
        '';
      };
    };
  };

  config = {
    home.packages = lib.mkIf cfg.installPackage (
      with pkgs;
      [
        bottom
      ]
    );

    xdg.configFile = {
      "bottom/bottom.toml".source = ../../../../Applications/bottom/bottom.toml;
    };
  };
}
