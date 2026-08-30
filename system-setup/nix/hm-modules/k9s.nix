{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.k9s;

  # the Catppuccin themes repo for k9s
  catppuccin-k9s = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "k9s";
    rev = "fdbec82284744a1fc2eb3e2d24cb92ef87ffb8b4";
    hash = "sha256-9h+jyEO4w0OnzeEKQXJbg9dvvWGZYQAO4MbgDn6QRzM=";
  };

  # the actual k9s theme files
  themes-dir = "${catppuccin-k9s}/dist/";
in
{
  imports = [ ./common.nix ];

  options.dotfiles.k9s = {
    enable = lib.mkEnableOption "k9s with dotfiles defaults";
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
        k9s
      ]
    );

    xdg.configFile = {
      "k9s/skins".source = themes-dir;
      "k9s/config.yaml".source =
        # TODO: might turn into a regular symlink - no need for outside mutation
        config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.repoPath}/Applications/k9s/config.yaml";
    };
  };
}
