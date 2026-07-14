{
  inputs,
  config,
  ...
}:

{
  imports = [
    inputs.agenix.homeManagerModules.default
    ../../hm-modules/linux
  ];

  # the user and their home path to be managed
  home.username = "murtadha";
  home.homeDirectory = "/home/murtadha";

  # Identity key used by agenix to decrypt all secrets on this host
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/keys/age.txt" ];

  dotfiles.syncthing = {
    # This host's unique Syncthing identity (the cert derives its Device ID)
    certFile = ../../secrets/syncthing-cert-nixos-desktop.age;
    keyFile = ../../secrets/syncthing-key-nixos-desktop.age;
    # Land the synced folder at ~/Documents/synced-documents on this workstation
    documentsPath = "Documents/synced-documents";
  };

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
