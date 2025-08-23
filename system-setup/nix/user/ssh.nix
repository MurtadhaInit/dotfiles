{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";

    # to be appended to ~/.ssh/config
    extraConfig = ''
      Host github.com
        IdentityFile ~/.ssh/keys/github
    '';
  };

  # Enable the OpenSSH private key agent
  services.ssh-agent.enable = true;
}
