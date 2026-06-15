{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.sesh;
in
{
  options.dotfiles.sesh = {
    enable = lib.mkEnableOption "sesh smart session manager for tmux with dotfiles defaults";
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the sesh package via Nix (vs. just configuring it)";
    };
  };

  config = lib.mkIf cfg.enable {
    # NOTE: picker (fzf) and zoxide source come from fzf/zoxide, which should be present on each host.
    # To fuzzy find projects from a predefined directory (e.g. ~/Projects), install fd too.
    home.packages = lib.mkIf cfg.installPackage [ pkgs.sesh ];

    xdg.configFile = {
      "sesh/sesh.toml".source = ../../../Applications/sesh/sesh.toml;
    };
  };
}
