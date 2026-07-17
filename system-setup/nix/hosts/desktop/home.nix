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

    ../../hm-modules/lsps.nix

    # Linux-specific
    ../../hm-modules/linux/ssh.nix
    ../../hm-modules/linux/brave.nix
    ../../hm-modules/linux/bun.nix
    ../../hm-modules/linux/packages.nix
    ../../hm-modules/linux/fonts.nix
    ../../hm-modules/linux/plasma.nix
    ../../hm-modules/linux/tailscale-systray.nix
  ];

  # the user and their home path to be managed
  home.username = "murtadha";
  home.homeDirectory = "/home/murtadha";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true; # let Home Manager install and manage itself

  # Identity key used by agenix to decrypt all secrets on this host
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/keys/age.txt" ];

  dotfiles.syncthing = {
    enable = true;
    # This host's unique Syncthing identity (the cert derives its Device ID)
    certFile = ../../secrets/syncthing-cert-nixos-desktop.age;
    keyFile = ../../secrets/syncthing-key-nixos-desktop.age;
    # Land the synced folder at ~/Documents/synced-documents on this workstation
    documentsPath = "Documents/synced-documents";
  };
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
  dotfiles.ssh.enable = true;
  dotfiles.brave.enable = true;
  dotfiles.bun.enable = true;
  dotfiles.packages.enable = true;
  dotfiles.k9s.enable = true;
  dotfiles.devbox.enable = true;
  dotfiles.fonts.enable = true;
  dotfiles.tmux.enable = true;
  dotfiles.sesh.enable = true;
  dotfiles.plasma.enable = true;
  dotfiles.tailscale-systray.enable = true;
}
