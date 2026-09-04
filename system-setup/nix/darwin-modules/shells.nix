{ ... }:

{
  # nix-darwin ships zsh and bash modules that are enabled by default, and each one
  # takes over the system-wide startup files: /etc/{zshenv,zprofile,zshrc} and
  # /etc/bashrc. Keeping them off leaves all four exactly as macOS and the Determinate
  # installer left them — notably the `export ZDOTDIR="$HOME/.config/zsh"` appended to
  # /etc/zshenv, which is the only thing pointing zsh at this repo's config.
  #
  # Nushell is unaffected either way: it is chsh'd as the login shell and sets up its
  # own PATH and Nix profile entries in Applications/nushell/config.nu.
  #
  # What we give up: nothing adds /run/current-system/sw/bin to PATH, so nix-darwin's
  # `environment.systemPackages` (darwin-rebuild included) has to be put on PATH by hand.
  programs.zsh.enable = false;
  programs.bash.enable = false;
}
