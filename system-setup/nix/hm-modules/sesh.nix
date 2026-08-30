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
    installDeps = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install sesh dependencies (CLIs) via Nix";
    };
  };

  config = lib.mkIf cfg.enable {
    # NOTE: picker (fzf) and zoxide source come from fzf/zoxide, which should be present on each host.
    # To fuzzy find projects from a predefined directory (e.g. ~/Projects), install fd too.
    home.packages =
      lib.optionals cfg.installPackage [
        pkgs.sesh
      ]
      ++ lib.optionals cfg.installDeps [
        pkgs.fzf
        pkgs.fd
        pkgs.zoxide
      ];

    xdg.configFile = {
      "sesh/sesh.toml".source = ../../../Applications/sesh/sesh.toml;
    };
  };
}
