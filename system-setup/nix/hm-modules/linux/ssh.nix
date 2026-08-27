{
  config,
  lib,
  ...
}:

let
  cfg = config.dotfiles.ssh;
in
# Linux-only: services.ssh-agent and systemd.user.sessionVariables don't exist
# on macOS (where the system ssh-agent + keychain integration is used instead).
# TODO: configure on macos and turn into a cross-platform HM module
{
  options.dotfiles.ssh = {
    enable = lib.mkEnableOption "SSH client with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      # Attribute names become `Host <name>` patterns; values are literal
      # ssh_config directives. `Host *` is rendered last, so the per-host
      # blocks below win wherever they overlap with it.
      settings = {
        "*".AddKeysToAgent = "yes";

        "github.com".IdentityFile = "~/.ssh/keys/github";

        # Proxmox nodes. Two logins per node: `root` & `murtadha`
        "prox-root" = {
          HostName = "10.20.30.40";
          User = "root";
          IdentityFile = "~/.ssh/keys/proxmox-hosts";
        };

        "prox-murtadha" = {
          HostName = "10.20.30.40";
          User = "murtadha";
          IdentityFile = "~/.ssh/keys/proxmox-hosts";
        };

        "prox2-root" = {
          HostName = "10.20.30.100";
          User = "root";
          IdentityFile = "~/.ssh/keys/proxmox-hosts";
        };

        "prox2-murtadha" = {
          HostName = "10.20.30.100";
          User = "murtadha";
          IdentityFile = "~/.ssh/keys/proxmox-hosts";
        };

        # Proxmox guests (VMs & LXCs)
        "ubuntu-vm" = {
          HostName = "10.20.30.41";
          User = "murtadha";
          IdentityFile = "~/.ssh/keys/proxmox-vms";
        };

        "nixos-ct" = {
          HostName = "10.20.30.50";
          User = "root";
          IdentityFile = "~/.ssh/keys/proxmox-vms";
        };
      };
    };

    services.ssh-agent.enable = true;

    systemd.user.sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";

      # macOS-keychain-like flow for key passphrases: route the prompt through
      # SSH_ASKPASS (Plasma sets it to ksshaskpass) even when ssh runs in a
      # terminal. ksshaskpass offers "remember in KWallet"; once saved - and with
      # the wallet PAM-unlocked at login - keys load without any typing.
      SSH_ASKPASS_REQUIRE = "prefer";
    };
  };
}
