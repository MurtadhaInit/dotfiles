{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };

      "github.com" = {
        identityFile = "~/.ssh/keys/github";
      };
    };
  };

  services.ssh-agent.enable = true;

  systemd.user.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
  };
}
