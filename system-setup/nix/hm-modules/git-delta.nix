{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.version-control;

  # the Catppuccin themes repo for delta
  catppuccin-delta = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "delta";
    rev = "011516f5d14f66b771b3e716f29c77231e008c74";
    hash = "sha256-lztkxX9O41YossvRzpR7tqxMhDNT1Efy2JvkCwtsiXQ=";
  };

  # the actual Delta theme file
  themes-file = "${catppuccin-delta}/catppuccin.gitconfig";
in
{
  options.dotfiles.version-control = {
    enable = lib.mkEnableOption "the version control module with dotfiles defaults";
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the package(s) via Nix (vs. just configure it)";
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: Git is installed globally with system packages
    home.packages = lib.mkIf cfg.installPackage (
      with pkgs;
      [
        delta
      ]
    );

    # TODO: Nix-style of configuring Git without external config files: https://nixos.wiki/wiki/Git
    xdg.configFile = {
      "git/config".source = ../../../Applications/git/config;
      "git/ignore".source = ../../../Applications/git/ignore;

      # Link the delta theme file
      # Note: the Bat Catppuccin theme is a prerequisite
      "git/delta/catppuccin.gitconfig".source = themes-file;
    };
  };
}
