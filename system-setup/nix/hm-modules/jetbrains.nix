{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.jetbrains;
in
{
  options = {
    programs.jetbrains = {
      installPackage = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install the JetBrains Toolbox package via Nix.
          Set to false if you want to use JetBrains Toolbox installed through other
          means (e.g., Homebrew) while still managing the configuration through Home Manager.
        '';
      };
    };
  };

  config = {
    home.packages = lib.mkIf cfg.installPackage (
      with pkgs;
      [
        jetbrains-toolbox
      ]
    );

    xdg.configFile = {
      "ideavim/ideavimrc".source = ../../../../Applications/ideavim/ideavimrc;
    };
  };
}
