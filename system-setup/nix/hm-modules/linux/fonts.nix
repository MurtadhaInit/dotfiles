{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.fonts;

  fontsDir = "${config.xdg.dataHome}/fonts";
  # Map key = the agenix secret NAME (its decrypted runtime path under
  # ~/.local/run/agenix/); value = the encrypted source file.
  # NOTE: keep these .age filenames free of spaces/parens. They're referenced as
  # plain Nix path literals (which can't contain spaces/parens), and agenix's CLI
  # (-e/-r) also builds an unquoted eval string from the filename and would split
  # on whitespace.
  fontsSecrets = {
    "fonts/MonoLisa-Plus-2.016.zip" = ../../secrets/fonts/MonoLisa-Plus-2.016.zip.age;
    "fonts/MonoLisa-Cursive-2.016.zip" = ../../secrets/fonts/MonoLisa-Cursive-2.016.zip.age;
    "fonts/Comic-Code-Coding-Essentials-Ligatures.zip" =
      ../../secrets/fonts/Comic-Code-Coding-Essentials-Ligatures.zip.age;
  };
  extractFonts = pkgs.writeShellScript "extract-fonts" ''
    set -euo pipefail
    archive="$1"
    dest="$2"
    fonts_dir="${fontsDir}"
    temp_dir="$(mktemp -d)"
    trap 'rm -rf "$temp_dir"' EXIT
    cd "$temp_dir"
    ${pkgs.unzip}/bin/unzip -q "$archive"
    mkdir -p "$fonts_dir/$dest"
    rm -rf "$fonts_dir/$dest"/*
    find . -type f \( -name "*.ttf" -o -name "*.otf" -o -name "*.woff" -o -name "*.woff2" \) -exec cp -f {} "$fonts_dir/$dest/" \;
    ${pkgs.fontconfig}/bin/fc-cache -f
  '';
in
{
  options.dotfiles.fonts = {
    enable = lib.mkEnableOption "agenix-encrypted licensed fonts (decrypt + unzip into ~/.local/share/fonts; Linux only)";
  };

  config = lib.mkIf cfg.enable {
    # NOTE: explicit static decryption paths. The HM-agenix default embeds
    # $XDG_RUNTIME_DIR, which is UNSET when home-manager-<user>.service activates
    # at boot (before any user session exists). Under the activation script's
    # `set -u`, the `[ -f "${archivePath}" ]` test below then expands an unbound
    # variable and aborts the ENTIRE activation — and because extractFonts runs
    # before linkGeneration, no home.file symlinks get created on a fresh boot
    # (they only appear after a `switch`, when you're logged in and the var is
    # set). A static path removes the dependency. Same workaround as syncthing.nix.
    age.secrets = lib.mapAttrs (name: filePath: {
      file = filePath;
      path = "${config.home.homeDirectory}/.local/run/agenix/${name}";
    }) fontsSecrets;

    home.activation.extractFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      ''
        set -eu
        fonts_dir="${fontsDir}"
        markers_dir="$fonts_dir/.markers"
        mkdir -p "$fonts_dir" "$markers_dir"

        compute_sha() { ${pkgs.coreutils}/bin/sha256sum "$1" | cut -d' ' -f1; }

        should_extract() {
          local archive="$1"
          local name="$2"
          local marker="$markers_dir/$name.sha256"
          if [ ! -f "$marker" ]; then
            return 0
          fi
          local current="$(compute_sha "$archive")"
          local saved="$(cat "$marker" 2>/dev/null || true)"
          [ "$current" != "$saved" ]
        }

        create_marker() {
          local archive="$1"
          local name="$2"
          local marker="$markers_dir/$name.sha256"
          ${pkgs.coreutils}/bin/sha256sum "$archive" | cut -d' ' -f1 > "$marker"
        }
      ''
      + lib.concatMapStringsSep "\n" (
        name:
        let
          secret = builtins.getAttr name config.age.secrets;
          archivePath = secret.path;
        in
        ''
          if [ -f "${archivePath}" ]; then
            archive="${archivePath}"
            archive_name="$(basename "$archive")"
            dest_dir="''${archive_name%.*}"
            if should_extract "$archive" "$archive_name"; then
              echo "Extracting $archive_name..."
              $DRY_RUN_CMD ${extractFonts} "$archive" "$dest_dir"
              $DRY_RUN_CMD create_marker "$archive" "$archive_name"
            else
              echo "$archive_name up to date, skipping extraction"
            fi
          fi
        ''
      ) (builtins.attrNames fontsSecrets)
    );
  };
}
