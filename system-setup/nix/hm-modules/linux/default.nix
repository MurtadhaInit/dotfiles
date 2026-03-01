{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Shared
    ../nushell.nix
    ../ghostty.nix
    ../eza.nix
    ../bat.nix
    ../bottom.nix
    ../lazygit.nix
    ../opencode.nix
    ../vscode.nix
    ../starship.nix
    ../jetbrains.nix
    ../git-delta.nix
    ../atuin.nix
    ../zed.nix
    ../glow.nix
    ../mise.nix

    ../LSPs.nix

    # Linux-specific
    ../librewolf.nix
    ../brave.nix
    ../qbittorrent.nix
    ../bun.nix
    ../packages.nix
    ../localsend.nix
  ];

  dotfiles.nushell.enable = true;
  dotfiles.ghostty.enable = true;
  dotfiles.eza.enable = true;
  dotfiles.bat.enable = true;
  dotfiles.bottom.enable = true;
  dotfiles.lazygit.enable = true;
  dotfiles.opencode.enable = true;
  dotfiles.vscode.enable = true;
  dotfiles.starship.enable = true;
  dotfiles.jetbrains.enable = true;
  dotfiles.version-control.enable = true;
  dotfiles.atuin.enable = true;
  dotfiles.zed.enable = true;
  dotfiles.glow.enable = true;
  dotfiles.mise.enable = true;
  dotfiles.lsps.enable = true;
  dotfiles.librewolf.enable = true;
  dotfiles.brave.enable = true;
  dotfiles.qbittorrent.enable = true;
  dotfiles.bun.enable = true;
  dotfiles.packages.enable = true;
  dotfiles.localsend.enable = true;
}
