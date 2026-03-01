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

    # macOS-specific
    ../linearmouse.nix
  ];

  # Use Homebrew packages instead of Nix on macOS
  dotfiles.nushell.enable = true;
  dotfiles.nushell.installPackage = false;
  dotfiles.ghostty.enable = true;
  dotfiles.ghostty.installPackage = false;
  dotfiles.eza.enable = true;
  dotfiles.eza.installPackage = false;
  dotfiles.bat.enable = true;
  dotfiles.bat.installPackage = false;
  dotfiles.bottom.enable = true;
  dotfiles.bottom.installPackage = false;
  dotfiles.lazygit.enable = true;
  dotfiles.lazygit.installPackage = false;
  dotfiles.lsps.enable = true;
  dotfiles.opencode.enable = true;
  dotfiles.zed.enable = true;
  dotfiles.zed.installPackage = false;
  dotfiles.vscode.enable = true;
  dotfiles.vscode.installPackage = false;
  dotfiles.starship.enable = true;
  dotfiles.starship.installPackage = false;
  dotfiles.atuin.enable = true;
  dotfiles.atuin.installPackage = false;
  dotfiles.jetbrains.enable = true;
  dotfiles.jetbrains.installPackage = false;
  dotfiles.version-control.enable = true;
  dotfiles.version-control.installPackage = false;
  dotfiles.linearmouse.enable = true;
  dotfiles.glow.enable = true;
  dotfiles.glow.installPackage = false;
  dotfiles.mise.enable = true;
  dotfiles.mise.installPackage = false;
}
