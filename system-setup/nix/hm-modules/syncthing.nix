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
  # POSTs them via the REST API), so we place the file ourselves via home.file
  # and restart the service on change so Syncthing re-reads it.
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
      default = "Desktop/Documents";
      description = "Path to the synced documents folder, relative to $HOME";
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
        file = ../secrets/syncthing-key.age;
        path = "${config.home.homeDirectory}/.local/run/agenix/syncthing-key";
      };
      syncthing-cert = {
        file = ../secrets/syncthing-cert.age;
        path = "${config.home.homeDirectory}/.local/run/agenix/syncthing-cert";
        mode = "0444";
      };
    };

    services.syncthing = {
      enable = true;
      key = config.age.secrets."syncthing-key".path;
      cert = config.age.secrets."syncthing-cert".path;
      passwordFile = config.age.secrets."syncthing-gui-password".path;
      settings = {
        gui = {
          user = "murtadha";
        };
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

    # Place .stignore in every managed folder root
    home.file."${cfg.documentsPath}/.stignore".source = stignore;

    # Restart Syncthing only when .stignore content changes between activations.
    # The nix store path is content-addressed, so a different path means different content.
    home.activation.restartSyncthing = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      _marker="$HOME/.local/state/syncthing-stignore-hash"
      _old=""
      [ -f "$_marker" ] && _old=$(${pkgs.coreutils}/bin/cat "$_marker")
      if [ "$_old" != "${stignore}" ]; then
        if [[ ! -v DRY_RUN ]]; then
          ${
            if pkgs.stdenv.isDarwin then
              "/bin/launchctl kickstart -k gui/$(/usr/bin/id -u)/org.nix-community.home.syncthing 2>/dev/null || true"
            else
              "systemctl --user restart syncthing 2>/dev/null || true"
          }
          ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname "$_marker")"
          echo "${stignore}" > "$_marker"
        else
          echo "Would restart Syncthing (stignore changed)"
        fi
      fi
    '';
  };
}
