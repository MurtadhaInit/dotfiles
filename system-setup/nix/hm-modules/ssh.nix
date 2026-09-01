{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfiles.ssh;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  options.dotfiles.ssh = {
    enable = lib.mkEnableOption "SSH client with dotfiles defaults";

    dropInFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = if isDarwin then ".ssh/config.d/dotfiles.conf" else null;
      example = ".ssh/config.d/dotfiles.conf";
      description = ''
        Where to render the generated ssh_config, relative to $HOME. `null` renders
        it as ~/.ssh/config, which then becomes a read-only store symlink.

        Any other path leaves ~/.ssh/config hand-writable so GUI apps can append to it,
        and the specified path is pulled in by an `Include` line seeded into ~/.ssh/config
        instead. Such a path is expected to sit in a directory of its own and end in `.conf`.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;

          # Attribute names become `Host <name>` patterns; values are literal
          # ssh_config directives. `Host *` is rendered last, so the per-host
          # blocks below win wherever they overlap with it.
          settings = {
            "*" = {
              AddKeysToAgent = "yes";
            }
            # Passphrases go to the login keychain: a key is unlocked once and
            # then loaded automatically on every later boot.
            // lib.optionalAttrs isDarwin { UseKeychain = "yes"; };

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

        # home-manager renders the settings above into `home.file.".ssh/config"`, where
        # the attribute name is only the default for `target` — the path the symlink
        # actually lands on. Overriding it relocates that same file, unmodified.
        home.file.".ssh/config".target = lib.mkIf (cfg.dropInFile != null) cfg.dropInFile;

        assertions = [
          {
            assertion = cfg.dropInFile == null || lib.hasSuffix ".conf" cfg.dropInFile;
            message = "dotfiles.ssh.dropInFile must end in `.conf`: the Include seeded into ~/.ssh/config is a `*.conf` glob over the drop-in's parent directory.";
          }
        ];

        # ~/.ssh/config stays outside Nix's control by design, so the one line that
        # reaches the drop-in has to be seeded imperatively.
        home.activation.sshDropInInclude = lib.mkIf (cfg.dropInFile != null) (
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            sshConfig="$HOME/.ssh/config"
            includeLine="Include ~/${dirOf cfg.dropInFile}/*.conf"

            if [[ ! -e $sshConfig ]] || ! grep -qF "$includeLine" "$sshConfig"; then
              noteEcho "Adding '$includeLine' to $sshConfig"
              if [[ ! -v DRY_RUN ]]; then
                mkdir -p -m 700 "$HOME/.ssh"
                # The separator covers an existing file whose last line has no
                # terminator, which would otherwise swallow the Include.
                (
                  umask 077
                  [[ -s $sshConfig ]] && printf '\n' >> "$sshConfig"
                  printf '%s\n' "$includeLine" >> "$sshConfig"
                )
              fi
            fi
          ''
        );
      }

      # macOS runs the system ssh-agent with keychain integration; neither of these
      # options exists there.
      (lib.mkIf (!isDarwin) {
        services.ssh-agent.enable = true;

        systemd.user.sessionVariables = {
          # TODO: testing removal
          # SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";

          # TODO: testing removal
          # macOS-keychain-like flow for key passphrases: route the prompt through
          # SSH_ASKPASS (Plasma sets it to ksshaskpass) even when ssh runs in a
          # terminal. ksshaskpass offers "remember in KWallet"; once saved - and with
          # the wallet PAM-unlocked at login - keys load without any typing.
          # SSH_ASKPASS_REQUIRE = "prefer";
        };
      })
    ]
  );
}
