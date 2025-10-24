{ config, pkgs, ... }:

{
  # Enable Nushell (add it to the list of shells)
  environment.shells = [
    pkgs.nushell
  ];

  # Make it the default user shell
  users.users.murtadha.shell = pkgs.nushell;
}
