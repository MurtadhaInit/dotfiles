{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.eza;

  # the Catppuccin themes repo for Eza
  catppuccin-nushell = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "eza";
    rev = "main";
    hash = "sha256-Q+C07IReQQBO5xYuFiFbS1wjmO4gdt/wIJWHNwIizSc=";
  };

  # the selected Eza theme file (flavour + accent)
  theme-file = "${catppuccin-nushell}/themes/mocha/catppuccin-mocha-mauve.yml";
in
{
  options = {
    programs.eza = {
      installPackage = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install the eza package via Nix.
          Set to false if you want to use eza installed through other means (e.g., Homebrew)
          while still managing the configuration through Home Manager.
        '';
      };
    };
  };

  config = {
    home.packages = lib.mkIf cfg.installPackage (
      with pkgs;
      [
        eza # also available as a flake
      ]
    );

    xdg.configFile = {
      "eza/theme.yml".source = theme-file;
    };
  };
}
