{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.version-control;

  # the Catppuccin themes repo for delta
  catppuccin-delta = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "delta";
    rev = "main";
    hash = "sha256-NjqqB/BHqduiNWKeksiRZUMfjRUodJlsVu1yaEIZRsM=";
  };

  # the actual Delta theme file
  themes-file = "${catppuccin-delta}/catppuccin.gitconfig";
in
{
  options = {
    programs.version-control = {
      installPackages = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install Git, Delta..etc packages via Nix.
          Set to false if you want to install those packages through other means (e.g., Homebrew)
          while still managing the configuration through Home Manager.
        '';
      };
    };
  };

  config = {
    # TODO: Git is installed globally with system packages
    home.packages = lib.mkIf cfg.installPackages (
      with pkgs;
      [
        delta
      ]
    );

    # TODO: Nix-style of configuring Git without external config files: https://nixos.wiki/wiki/Git
    xdg.configFile = {
      "git/config".source = ../../../../Applications/git/config;
      "git/ignore".source = ../../../../Applications/git/ignore;

      # Link the delta theme file
      # Note: the Bat Catppuccin theme is a prerequisite
      "git/delta/catppuccin.gitconfig".source = themes-file;
    };
  };
}
