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

    // Common temp/lock files
    ~*
    *.tmp
    *.swp
  '';
in
{
  options.dotfiles.syncthing = {
    enable = lib.mkEnableOption "Enable Syncthing with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    # Agenix — decrypt the GUI password at activation time
    age.identityPaths = [ "${config.home.homeDirectory}/.ssh/keys/age.txt" ];
    age.secrets."syncthing-gui-password" = {
      file = ../secrets/syncthing-gui-password.age;
      # Explicit static path so the HM syncthing module can reference it at
      # eval time — the default macOS path contains a shell expansion that
      # fails the `types.path` check on `passwordFile`.
      path = "${config.home.homeDirectory}/.local/run/agenix/syncthing-gui-password";
    };

    services.syncthing = {
      enable = true;
      # Don't clobber devices/folders added through the GUI
      overrideDevices = false;
      overrideFolders = false;
      passwordFile = config.age.secrets."syncthing-gui-password".path;
      settings = {
        gui = {
          user = "murtadha";
        };
        folders = {
          documents = {
            id = "documents";
            path = "${config.home.homeDirectory}/Desktop/Documents";
            label = "Documents";
            ignorePerms = true;
          };
        };
      };
    };

    # Place .stignore in every managed folder root
    home.file."Desktop/Documents/.stignore".source = stignore;

    # Restart Syncthing after activation so it re-reads .stignore from disk
    home.activation.restartSyncthing = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      /bin/launchctl kickstart -k gui/$(/usr/bin/id -u)/org.nix-community.home.syncthing 2>/dev/null || true
    '';
  };
}
