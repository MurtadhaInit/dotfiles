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
  dotfiles.cli-packages.enable = false;
  dotfiles.nushell = {
    installPackage = false;
    installDeps = false;
  };
  dotfiles.ghostty.installPackage = false;
  dotfiles.eza.installPackage = false;
  dotfiles.bat.installPackage = false;
  dotfiles.bottom.installPackage = false;
  dotfiles.lazygit.installPackage = false;
  dotfiles.zed.installPackage = false;
  dotfiles.vscode.installPackage = false;
  dotfiles.starship.installPackage = false;
  dotfiles.atuin.installPackage = false;
  dotfiles.jetbrains.installPackage = false;
  dotfiles.version-control.installPackage = false;
  dotfiles.glow.installPackage = false;
  dotfiles.mise.installPackage = false;
  dotfiles.k9s.installPackage = false;
  dotfiles.sesh.installDeps = false;
}
