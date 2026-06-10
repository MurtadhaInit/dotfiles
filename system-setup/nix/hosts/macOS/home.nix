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

  # This host's unique Syncthing identity (the cert derives its Device ID)
  dotfiles.syncthing.certFile = ../../secrets/syncthing-cert-macbook.age;
  dotfiles.syncthing.keyFile = ../../secrets/syncthing-key-macbook.age;

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
