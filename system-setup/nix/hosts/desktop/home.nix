{
  inputs,
  ...
}:

{
  imports = [
    inputs.agenix.homeManagerModules.default
    ../../hm-modules/linux

    ../../hm-modules/ssh.nix
    ../../hm-modules/agenix-fonts.nix
  ];

  # the user and their home path to be managed
  home.username = "murtadha";
  home.homeDirectory = "/home/murtadha";

  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
