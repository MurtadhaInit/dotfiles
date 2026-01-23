{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.glow;

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
  options = {
    programs.glow = {
      installPackage = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install the Glow package via Nix.
          Set to false if you want to use Glow installed through other means (e.g., Homebrew)
          while still managing the configuration through Home Manager.
        '';
      };
    };
  };

  config = {
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
