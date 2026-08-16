{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.eza;

  # the Catppuccin themes repo for Eza
  catppuccin-nushell = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "eza";
    rev = "70f805f6cc27fa5b91750b75afb4296a0ec7fec9";
    hash = "sha256-Q+C07IReQQBO5xYuFiFbS1wjmO4gdt/wIJWHNwIizSc=";
  };

  # the selected Eza theme file (flavour + accent)
  theme-file = "${catppuccin-nushell}/themes/mocha/catppuccin-mocha-mauve.yml";
in
{
  options.dotfiles.eza = {
    enable = lib.mkEnableOption "Eza with dotfiles defaults";
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
        eza # also available as a flake
      ]
    );

    xdg.configFile = {
      "eza/theme.yml".source = theme-file;
    };
  };
}
