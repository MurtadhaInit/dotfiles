# When Nix itself is installed and owned by Determinate, nix-darwin must not write
# /etc/nix/nix.conf or run a nix-daemon of its own. This module sets
# `nix.enable = false` on our behalf and, in exchange, generates
# /etc/nix/nix.custom.conf — the file Determinate's nix.conf `!include`s.
#
# Consequence: that file is regenerated in full, so every setting the installer
# (or you manually) put there has to be declared below or it is silently dropped.
{ ... }:

{
  determinateNix = {
    enable = true;

    # Custom settings written to /etc/nix/nix.custom.conf
    customSettings = {
      use-case-hack = false;
      builders-use-substitutes = true;
    };

    # Custom settings written to /etc/determinate/config.json
    # determinateNixd = {
    #   garbageCollector.strategy = "disabled";
    #   authentication.additionalNetrcSources = [
    #     "/path/to/custom/netrc"
    #   ];
    # };

    # Self-hosted NixOS LXC container as a Linux builder.
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "10.20.30.50";
        protocol = "ssh-ng";
        sshUser = "nix-builder";
        sshKey = "/var/root/.ssh/nix-builder";
        system = "x86_64-linux";
        maxJobs = 2;
        speedFactor = 1;
        supportedFeatures = [ "big-parallel" ];
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU1kdzR3Z3hsR0d6Z09tSHJaRXAwc3FBd21hNDRkV2xHenc2L3h5U0xoaUoK";
      }
    ];
  };
}
