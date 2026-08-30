# The cross-platform command-line environment: tools that make a shell usable on any
# host, headless ones included. Every host is expected to take this profile.
#
# Nothing here assumes a display server, a login session, or decrypted secrets.
{ ... }:

{
  imports = [
    ../hm-modules/atuin.nix
    ../hm-modules/bat.nix
    ../hm-modules/bottom.nix
    ../hm-modules/claude-code.nix
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
  dotfiles = {
    atuin.enable = true;
    bat.enable = true;
    bottom.enable = true;
    claude-code.enable = true;
    devbox.enable = true;
    eza.enable = true;
    glow.enable = true;
    herdr.enable = true;
    k9s.enable = true;
    lazygit.enable = true;
    lsps.enable = true;
    mise.enable = true;
    nushell.enable = true;
    opencode.enable = true;
    sesh.enable = true;
    starship.enable = true;
    tmux.enable = true;
    version-control.enable = true; # git-delta.nix
  };
}
