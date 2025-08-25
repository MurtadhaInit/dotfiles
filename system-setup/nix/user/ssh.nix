{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";

    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/keys/github";
      };
    };
  };

  # Enable the OpenSSH private key agent
  # services.ssh-agent.enable = true;
}
