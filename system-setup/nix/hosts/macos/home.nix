{
  inputs,
  config,
  ...
}:

{
  imports = [
    inputs.agenix.homeManagerModules.default

    # Shared
    ../../hm-modules/nushell.nix
    ../../hm-modules/ghostty.nix
    ../../hm-modules/eza.nix
    ../../hm-modules/bat.nix
    ../../hm-modules/bottom.nix
    ../../hm-modules/lazygit.nix
    ../../hm-modules/opencode.nix
    ../../hm-modules/vscode.nix
    ../../hm-modules/starship.nix
    ../../hm-modules/jetbrains.nix
    ../../hm-modules/git-delta.nix
    ../../hm-modules/atuin.nix
    ../../hm-modules/zed.nix
    ../../hm-modules/glow.nix
    ../../hm-modules/mise.nix
    ../../hm-modules/k9s.nix
    ../../hm-modules/syncthing.nix
    ../../hm-modules/devbox.nix
    ../../hm-modules/tmux.nix
    ../../hm-modules/sesh.nix
    ../../hm-modules/claude-code.nix

    ../../hm-modules/lsps.nix

    # macOS-specific
    ../../hm-modules/macos/linearmouse.nix
    ../../hm-modules/macos/tuna.nix
  ];

  # the user and their home path to be managed
  home.username = "murtadha";
  home.homeDirectory = "/Users/murtadha";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true; # let Home Manager install and manage itself

  # Identity key used by agenix to decrypt all secrets on this host
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/keys/age.txt" ];

  dotfiles.syncthing = {
    enable = true;
    # This host's unique Syncthing identity (the cert derives its Device ID)
    certFile = ../../secrets/syncthing-cert-macbook.age;
    keyFile = ../../secrets/syncthing-key-macbook.age;
    # Land the synced folder at ~/Desktop/Documents on this machine
    documentsPath = "Desktop/Documents";
  };
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
  dotfiles.k9s.enable = true;
  dotfiles.k9s.installPackage = false;
  dotfiles.tuna.enable = true;
  dotfiles.devbox.enable = true;
  dotfiles.tmux.enable = true;
  dotfiles.sesh.enable = true;
  dotfiles.claude-code.enable = true;
}
