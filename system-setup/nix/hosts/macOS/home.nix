{
  inputs,
  config,
  ...
}:

{
  imports = [
    inputs.agenix.homeManagerModules.default
    ../../hm-modules/macos
  ];

  # the user and their home path to be managed
  home.username = "murtadha";
  home.homeDirectory = "/Users/murtadha";

  # Identity key used by agenix to decrypt all secrets on this host
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/keys/age.txt" ];

  dotfiles.syncthing = {
    # This host's unique Syncthing identity (the cert derives its Device ID)
    certFile = ../../secrets/syncthing-cert-macbook.age;
    keyFile = ../../secrets/syncthing-key-macbook.age;
    # Land the synced folder at ~/Desktop/Documents on this machine
    documentsPath = "Desktop/Documents";
  };

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
