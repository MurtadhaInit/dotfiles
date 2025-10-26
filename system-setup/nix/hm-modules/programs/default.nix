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
    ./helix.nix
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

    ./LSPs.nix

    # Linux
    ./librewolf.nix
    ./brave.nix
    ./qbittorrent.nix
    ./bun.nix
    ./packages.nix
  ];

  config = lib.mkMerge [
    # === macOS specific options ===
    (lib.mkIf pkgs.stdenv.isDarwin {
      # Use Homebrew packages instead of Nix on macOS
      programs.nushell.installPackage = false;
      programs.ghostty.installPackage = false;
      programs.eza.installPackage = false;
      programs.bat.installPackage = false;
      programs.bottom.installPackage = false;
      programs.lazygit.installPackage = false;
      programs.vscode.enable = false; # don't install through Nix
      programs.starship.enable = false; # don't install through Nix
      programs.atuin.enable = false; # don't install through Nix
      programs.jetbrains.installPackage = false;
      programs.version-control.installPackages = false;

      # Linux-only programs
      programs.librewolf.enable = false;
      programs.chromium.enable = false; # for Brave
      qbittorrent.enable = false;
      bun.enable = false;
      packages.enable = false;
    })

    # === Linux specific options ===
    (lib.mkIf pkgs.stdenv.isLinux {
      # Install packages via Nix on Linux (default behavior)
      # Add any Linux-specific configuration here
      programs.librewolf.enable = true;
      programs.chromium.enable = true; # for Brave
      qbittorrent.enable = true;
      bun.enable = true;
      packages.enable = true;
    })
  ];
}
