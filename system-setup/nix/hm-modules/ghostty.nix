{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.ghostty;

  # the Catppuccin themes repo for Ghostty
  catppuccin-ghostty = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "ghostty";
    rev = "5a58926563ddacbde4a12b4a347464c2c6945393";
    hash = "sha256-Y6RFften1/6+1xdhIzEh/E7FBJTwY5a8NH4301HbgOM=";
  };

  # the actual Ghostty theme files
  themes-dir = "${catppuccin-ghostty}/themes/";
in
{
  options.dotfiles.ghostty = {
    enable = lib.mkEnableOption "Ghostty with dotfiles defaults";
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
        ghostty
      ]
    );

    xdg.configFile = {
      "ghostty/themes".source = themes-dir;
      "ghostty/config".source = ../../../Applications/ghostty/config;
    }
    # Linux-specific options, pulled in inside the shared config via `config-file = ?linux.conf`
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      "ghostty/linux.conf".source = ../../../Applications/ghostty/linux.conf;
    };
  };
}
