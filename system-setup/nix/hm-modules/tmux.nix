{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.tmux;

  # Plugins are managed and pinned by Nix instead of TPM.
  # Each plugin's store directory is symlinked into ~/.config/tmux/plugins/<name>.
  # tmux.conf sources the entry script from that stable path with `run`.
  #
  # NOTE: mkTmuxPlugin installs each plugin under $out/share/tmux-plugins/<name>/.
  plugins = {
    catppuccin = "${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin";
    resurrect = "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect";
    continuum = "${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum";
  };
in
{
  options.dotfiles.tmux = {
    enable = lib.mkEnableOption "tmux with dotfiles defaults";
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the tmux package via Nix (vs. just configuring it)";
    };
  };

  config = lib.mkIf cfg.enable {
    # Install tmux directly rather than via programs.tmux: the latter generates its own
    # tmux.conf, which would collide with the hand-written one symlinked config below.
    home.packages = lib.mkIf cfg.installPackage [ pkgs.tmux ];

    xdg.configFile = {
      "tmux/tmux.conf".source = ../../../Applications/tmux/tmux.conf;
      "tmux/plugins/catppuccin".source = plugins.catppuccin;
      "tmux/plugins/resurrect".source = plugins.resurrect;
      "tmux/plugins/continuum".source = plugins.continuum;
    };
  };
}
