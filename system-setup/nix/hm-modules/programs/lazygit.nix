{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.lazygit;
in
{
  options = {
    programs.lazygit = {
      installPackage = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install the lazygit package via Nix.
          Set to false if you want to use lazygit installed through other means (e.g., Homebrew)
          while still managing the configuration through Home Manager.
        '';
      };
    };
  };

  config = {
    home.packages = lib.mkIf cfg.installPackage (
      with pkgs;
      [
        lazygit
      ]
    );

    # TODO: might switch to the standalone theme file from Catppuccin
    xdg.configFile = {
      "lazygit/config.yml".source = ../../../../Applications/lazygit/config.yml;
    };
  };
}
