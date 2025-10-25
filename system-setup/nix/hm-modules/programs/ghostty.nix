{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.ghostty;

  # the Catppuccin themes repo for Ghostty
  catppuccin-ghostty = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "ghostty";
    rev = "main";
    hash = "sha256-j0HCakM9R/xxEjWd5A0j8VVlg0vQivjlAYHRW/4OpGU=";
  };

  # the actual Ghostty theme files
  themes-dir = "${catppuccin-ghostty}/themes/";
in
{
  options = {
    programs.ghostty = {
      installPackage = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install the Ghostty package via Nix.
          Set to false if you want to use Ghostty installed through other means (e.g., Homebrew)
          while still managing the configuration through Home Manager.
        '';
      };
    };
  };

  config = {
    home.packages = lib.mkIf cfg.installPackage (
      with pkgs;
      [
        ghostty
      ]
    );

    xdg.configFile = {
      "ghostty/themes".source = themes-dir;
      "ghostty/config".source = ../../../../Applications/ghostty/config;
    };
  };
}
