# nix-darwin ships zsh and bash modules that are enabled by default, and each one takes
# over the system-wide startup files: /etc/{zshenv,zprofile,zshrc} and /etc/bashrc.
# Keeping them off leaves all four exactly as macOS and the Determinate installer left
# them. We instead manage the user level zsh config in home-manager (zsh.nix).
#
# Two things to weigh before turning them on:
#
#   - /etc/zshenv and /etc/bashrc no longer match any hash nix-darwin recognises, so
#     activation aborts until both are renamed to *.before-nix-darwin.
#   - nix-darwin's /etc/zprofile drops the `path_helper` call, replacing it with a fixed
#     `environment.systemPath`. Entries under /etc/paths.d (Wireshark, rvictl, cryptex,
#     /pkg/env/global/bin) would stop reaching zsh unless re-added there.
#
# Interactive tools launch Nushell explicitly, independently of the account's login
# shell (i.e. zsh). Both shells set up their own Nix profile entries — including
# /run/current-system/sw/bin, which is where darwin-rebuild lives: Nushell in
# `config.nu` (which also reads /etc/paths itself), and zsh in `.zprofile`.
{ ... }:

{
  programs.zsh.enable = false;
  programs.bash.enable = false;
}
