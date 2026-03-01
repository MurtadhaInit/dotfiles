{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.glow;

  # the Catppuccin themes repo for Glamour (theme format used by Glow)
  catppuccin-nushell = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "glamour";
    rev = "main";
    hash = "sha256-SI/COnVFdKltMRqeqLTbR/Rh0xUJcWSqiX/YlR221eo=";
  };

  # the selected Glamour theme file (replace 'mocha' with 'frappe', 'latte', or 'macchiato')
  theme-file = "${catppuccin-nushell}/themes/catppuccin-mocha.json";
in
{
  options.dotfiles.glow = {
    enable = lib.mkEnableOption "Enable Glow with dotfiles defaults";
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
        glow
      ]
    );

    xdg.configFile = {
      "glow/glow.yml".text = ''
        # style name or JSON path (default "auto")
        style: ${theme-file}
        # mouse support (TUI-mode only)
        mouse: false
        # use pager to display markdown
        pager: false
        # word-wrap at width
        width: 80
        # show all files, including hidden and ignored.
        all: false
      '';
    };
  };
}
