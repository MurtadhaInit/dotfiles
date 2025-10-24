{
  config,
  pkgs,
  lib,
  ...
}:

let
  fontsDir = "${config.xdg.dataHome}/fonts";
  fontsBase = ../../secrets/fonts;
  fontsSecrets = {
    "fonts/MonoLisa-Plus-2.016.zip" = builtins.path {
      path = builtins.toPath (builtins.toString fontsBase + "/MonoLisa-Plus-2.016.zip.age");
      name = "MonoLisa-Plus-2.016.zip.age";
    };
    "fonts/MonoLisa-Cursive-2.016.zip" = builtins.path {
      path = builtins.toPath (builtins.toString fontsBase + "/MonoLisa-Cursive-2.016.zip.age");
      name = "MonoLisa-Cursive-2.016.zip.age";
    };
    "fonts/Comic Code Coding Essentials (Ligatures).zip" = builtins.path {
      path = builtins.toPath (
        builtins.toString fontsBase + "/Comic Code Coding Essentials (Ligatures).zip.age"
      );
      name = "Comic-Code-Coding-Essentials-Ligatures.zip.age";
    };
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
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/keys/age.txt" ];

  age.secrets = lib.mapAttrs (_: filePath: { file = filePath; }) fontsSecrets;

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
}
