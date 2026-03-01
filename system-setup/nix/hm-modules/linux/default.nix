{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Shared
    ./nushell.nix
    ./ghostty.nix
    ./eza.nix
    ./bat.nix
    ./bottom.nix
    ./lazygit.nix
    ./opencode.nix
    ./vscode.nix
    ./starship.nix
    ./jetbrains.nix
    ./git-delta.nix
    ./atuin.nix
    ./zed.nix
    ./glow.nix
    ./mise.nix

    ./LSPs.nix

    # Linux-specific
    ./librewolf.nix
    ./brave.nix
    ./qbittorrent.nix
    ./bun.nix
    ./packages.nix
    ./localsend.nix
  ];

  dotfiles.librewolf.enable = true;
  dotfiles.brave.enable = true;
  dotfiles.qbittorrent.enable = true;

  dotfiles.lsps.enable = true;
  dotfiles.opencode.enable = true;
  dotfiles.zed.enable = true;

  dotfiles.localsend.enable = true;
  dotfiles.bun.enable = true;
  dotfiles.packages.enable = true;
}
