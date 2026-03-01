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
    rev = "main";
    hash = "sha256-Q+C07IReQQBO5xYuFiFbS1wjmO4gdt/wIJWHNwIizSc=";
  };

  # the selected Eza theme file (flavour + accent)
  theme-file = "${catppuccin-nushell}/themes/mocha/catppuccin-mocha-mauve.yml";
in
{
  options.dotfiles.eza = {
    enable = lib.mkEnableOption "Enable Eza with dotfiles defaults";
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
