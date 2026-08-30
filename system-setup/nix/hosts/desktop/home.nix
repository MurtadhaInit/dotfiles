{
  inputs,
  config,
  ...
}:

{
  imports = [
    ../../profiles/cli.nix
    ../../profiles/gui.nix

    # Secrets are opt-in per host: importing agenix commits this machine to holding the
    # age identity, and a missing key fails the whole activation.
    inputs.agenix.homeManagerModules.default
    ../../hm-modules/syncthing.nix
    ../../hm-modules/linux/fonts.nix

    # Linux + host specific
    ../../hm-modules/linux/ssh.nix
    ../../hm-modules/linux/bun.nix
    ../../hm-modules/linux/packages.nix
    ../../hm-modules/linux/plasma.nix
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
  dotfiles.fonts.enable = true; # agenix-encrypted licensed fonts

  dotfiles.ssh.enable = true;
  dotfiles.bun.enable = true;
  dotfiles.packages.enable = true;
  dotfiles.plasma = {
    enable = true;
    wallpaper = ../../wallpapers/wallhaven-qrlwz7.jpg;
  };
}
