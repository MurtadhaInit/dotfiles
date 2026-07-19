{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.syncthing;

  # .stignore is a per-folder file that Syncthing reads from the folder root.
  # The HM module doesn't support ignorePatterns (unlike the NixOS module which
  # POSTs them via the REST API), so we place the file ourselves via an
  # activation script and restart the service on change so Syncthing re-reads it.
  stignore = pkgs.writeText ".stignore" ''
    // macOS metadata
    (?d).DS_Store
    (?d)._*
    (?d).Spotlight-V100
    (?d).Trashes

    // Linux metadata
    (?d).Trash-*
    .directory

    // Common temp/lock files
    ~*
    *.tmp
    *.swp
  '';
in
{
  options.dotfiles.syncthing = {
    enable = lib.mkEnableOption "Syncthing with dotfiles defaults";
    documentsPath = lib.mkOption {
      type = lib.types.str;
      description = "Path to the synced documents folder, relative to $HOME";
    };
    # No defaults on purpose: the certificate hashes into the Syncthing Device
    # ID, so every host MUST supply its own unique identity. Set both in the host's home.nix.
    # A default here would silently let two hosts share one Device ID (a broken state on the hub).
    certFile = lib.mkOption {
      type = lib.types.path;
      description = "agenix-encrypted Syncthing TLS certificate for THIS host (derives its Device ID). Must be unique per host.";
    };
    keyFile = lib.mkOption {
      type = lib.types.path;
      description = "agenix-encrypted Syncthing TLS private key for THIS host. Generated alongside the TLS certificate.";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets = {
      syncthing-gui-password = {
        file = ../secrets/syncthing-gui-password.age;
        # Explicit static path — HM agenix (age-home.nix) defaults to a shell
        # expansion on both platforms ($XDG_RUNTIME_DIR on Linux, $(getconf ...)
        # on macOS) which fails the `types.path` check on `passwordFile` at Nix
        # eval time. NixOS-level agenix doesn't have this issue as it uses the
        # static /run/agenix/ path.
        path = "${config.home.homeDirectory}/.local/run/agenix/syncthing-gui-password";
      };
      syncthing-key = {
        file = cfg.keyFile;
        path = "${config.home.homeDirectory}/.local/run/agenix/syncthing-key";
      };
      syncthing-cert = {
        file = cfg.certFile;
        path = "${config.home.homeDirectory}/.local/run/agenix/syncthing-cert";
        mode = "0444";
      };
    };

    services.syncthing = {
      enable = true;
      key = config.age.secrets."syncthing-key".path;
      cert = config.age.secrets."syncthing-cert".path;
      guiCredentials = {
        username = "murtadha";
        passwordFile = config.age.secrets."syncthing-gui-password".path;
      };
      settings = {
        devices = {
          nixos-ct = {
            id = "HQ37GBK-Y7FFD6J-OUQBW7O-VMJOMNY-C3BWNGF-BOYZHX4-7WRGUDB-APF2GA5";
          };
        };
        folders = {
          documents = {
            id = "documents";
            path = "${config.home.homeDirectory}/${cfg.documentsPath}";
            label = "Documents";
            ignorePerms = true;
            # Simple trash can versioning for changes received from the homelab
            # hub — the hub itself keeps staggered versioning for deeper history.
            versioning = {
              type = "trashcan";
              params.cleanoutDays = "30";
            };
            devices = [ "nixos-ct" ];
          };
        };
      };
    };

    # Cold-boot ordering (Linux). agenix decrypts our cert/key/password via its
    # own `agenix.service` user unit, but nothing orders syncthing after it. If
    # syncthing wins the race, its ExecStartPre can't install the not-yet-decrypted
    # cert/key, its first start fails, and the syncthing-init oneshot
    # (Requires=syncthing.service) cascade-aborts and is never retried — so the GUI
    # password, folders and devices never get pushed and Syncthing looks like a
    # fresh, unconfigured install. Ordering after agenix guarantees the secrets exist.
    systemd.user.services.syncthing = lib.mkIf pkgs.stdenv.isLinux {
      Unit = {
        After = [ "agenix.service" ];
        Wants = [ "agenix.service" ];
      };
    };

    # Copy the .stignore file directly into synced directories, then restart Syncthing
    # only when the content differs from what is already on disk.
    # Self-healing: a manual edit is restored on the next switch.
    #
    # NOTE: materialise .stignore as a REAL file in the synced folder root, NOT a symlink
    # into the Nix store (e.g. with home.file) because Syncthing's per-folder filesystem
    # is rooted at the folder path and refuses to traverse a symlink whose target escapes
    # that root: it surfaces as ELOOP ("too many levels of symbolic links") even though
    # The OS resolves the link fine.
    #
    # NOTE: the Linux restart must set XDG_RUNTIME_DIR explicitly: this activation runs
    # inside the `home-manager-<user>.service` system unit, whose environment has
    # no XDG_RUNTIME_DIR, so a bare `systemctl --user` can't reach the user bus and
    # silently no-ops (the `|| true` hides it). We mirror the exact fallback
    # home-manager itself uses for its `reloadSystemd` step. On macOS, launchd is
    # reachable from the activation context, so `launchctl kickstart` is enough.
    home.activation.syncthingStignore = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      _dest="$HOME/${cfg.documentsPath}/.stignore"
      if [ ! -e "$_dest" ] || ! ${pkgs.coreutils}/bin/cmp -s "${stignore}" "$_dest"; then
        if [[ ! -v DRY_RUN ]]; then
          ${pkgs.coreutils}/bin/install -m 0644 -D "${stignore}" "$_dest"
          ${
            if pkgs.stdenv.isDarwin then
              "/bin/launchctl kickstart -k gui/$(/usr/bin/id -u)/org.nix-community.home.syncthing 2>/dev/null || true"
            else
              ''env XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(${pkgs.coreutils}/bin/id -u)}" systemctl --user restart syncthing 2>/dev/null || true''
          }
        else
          echo "Would write $_dest and restart Syncthing (stignore changed)"
        fi
      fi
    '';
  };
}
