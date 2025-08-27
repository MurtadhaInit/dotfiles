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

  services.ssh-agent.enable = true;

  home.packages = with pkgs; [
    kdePackages.ksshaskpass
  ];

  systemd.user.sessionVariables = {
    SSH_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    SSH_ASKPASS_REQUIRE = "prefer";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent"; # TODO: try removing as well as others
  };

  services.kdeconnect.enable = true;
}
