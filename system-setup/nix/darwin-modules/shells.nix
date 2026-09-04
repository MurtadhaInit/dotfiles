# nix-darwin ships zsh and bash modules that are enabled by default, and each one takes
# over the system-wide startup files: /etc/{zshenv,zprofile,zshrc} and /etc/bashrc.
# Keeping them off leaves all four exactly as macOS and the Determinate installer left
# them — notably the `export ZDOTDIR="$HOME/.config/zsh"` appended to /etc/zshenv, which
# is the only thing pointing zsh at this repo's config.
#
# Two things to weigh before turning them on, beyond re-declaring ZDOTDIR through
# `programs.zsh.shellInit`:
#
#   - /etc/zshenv and /etc/bashrc no longer match any hash nix-darwin recognises, so
#     activation aborts until both are renamed to *.before-nix-darwin.
#   - nix-darwin's /etc/zprofile drops the `path_helper` call, replacing it with a fixed
#     `environment.systemPath`. Entries under /etc/paths.d (Wireshark, rvictl, cryptex,
#     /pkg/env/global/bin) would stop reaching zsh unless re-added there.
#
# Nushell is unaffected either way, and gains nothing from turning them on: it is chsh'd
# as the login shell, so no zsh or bash startup file ever runs for a login session. It
# reads /etc/paths itself and sets up its own Nix profile entries in
# Applications/nushell/config.nu — including /run/current-system/sw/bin, which is where
# darwin-rebuild lives.
{ ... }:

{
  programs.zsh.enable = false;
  programs.bash.enable = false;
}
