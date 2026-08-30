# The cross-platform command-line environment: tools that make a shell usable on any
# host, headless ones included. Every host is expected to take this profile.
#
# Nothing here assumes a display server, a login session, or decrypted secrets.
{ lib, ... }:

{
  imports = [
    ../hm-modules/atuin.nix
    ../hm-modules/bat.nix
    ../hm-modules/bottom.nix
    ../hm-modules/claude-code.nix
    ../hm-modules/cli-packages.nix
    ../hm-modules/devbox.nix
    ../hm-modules/eza.nix
    ../hm-modules/git-delta.nix
    ../hm-modules/glow.nix
    ../hm-modules/herdr.nix
    ../hm-modules/k9s.nix
    ../hm-modules/lazygit.nix
    ../hm-modules/lsps.nix
    ../hm-modules/mise.nix
    ../hm-modules/nushell.nix
    ../hm-modules/opencode.nix
    ../hm-modules/sesh.nix
    ../hm-modules/starship.nix
    ../hm-modules/tmux.nix
  ];

  # Only `enable` belongs in a profile. E.g. whether Nix supplies the binary is host
  # policy (macOS defers to Homebrew), so hosts set `installPackage` themselves.
  #
  # Using mkDefault so a host can opt out with a plain `false` for any module.
  dotfiles = {
    atuin.enable = lib.mkDefault true;
    bat.enable = lib.mkDefault true;
    bottom.enable = lib.mkDefault true;
    claude-code.enable = lib.mkDefault true;
    cli-packages.enable = lib.mkDefault true;
    devbox.enable = lib.mkDefault true;
    eza.enable = lib.mkDefault true;
    glow.enable = lib.mkDefault true;
    herdr.enable = lib.mkDefault true;
    k9s.enable = lib.mkDefault true;
    lazygit.enable = lib.mkDefault true;
    lsps.enable = lib.mkDefault true;
    mise.enable = lib.mkDefault true;
    nushell.enable = lib.mkDefault true;
    opencode.enable = lib.mkDefault true;
    sesh.enable = lib.mkDefault true;
    starship.enable = lib.mkDefault true;
    tmux.enable = lib.mkDefault true;
    version-control.enable = lib.mkDefault true; # git-delta.nix
  };
}
