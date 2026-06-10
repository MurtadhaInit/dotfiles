let
  # Age public keys per host.
  # Generate a key pair with: age-keygen -o ~/.ssh/keys/age.txt
  # Print the public key with: age-keygen -y ~/.ssh/keys/age.txt
  macbook = "age1fjfzlw6ah4k3kh07ray363e87rt6z8rfhljjxprwhqa7y0pw9vjqvv0f9h";
  nixos-desktop = "age1qdu4rnxyr4je9vas54xv9q27mwxuml4afv84xry0uq9nws348uasfev9nw";
  allHosts = [
    macbook
    nixos-desktop
  ];
in
{
  # Edit with (in this dir): nix run github:ryantm/agenix -- -e <filename>.age
  # Re-encrypt from a file (Nushell): open <filename.key> | nix run github:ryantm/agenix -- -e <filename>.age
  # Re-key all secrets with: `agenix -r` providing (with -i) the minimum required private key(s) to decrypt

  "syncthing-gui-password.age".publicKeys = allHosts;
  # Per-host Syncthing TLS identity. The cert hashes into the Device ID, so each
  # host gets its own cert/key.
  # Generate a pair with: nix run nixpkgs#syncthing -- generate --config ./conf --data ./data
  # Then (Nushell): open ./conf/cert.pem | nix run github:ryantm/agenix -- -e syncthing-cert-<host>.age
  # And:            open ./conf/key.pem  | nix run github:ryantm/agenix -- -e syncthing-key-<host>.age
  # Get Device ID (for the hub): nix run nixpkgs#syncthing -- device-id --config ./conf --data ./data
  "syncthing-cert-macbook.age".publicKeys = allHosts;
  "syncthing-key-macbook.age".publicKeys = allHosts;
  "syncthing-cert-nixos-desktop.age".publicKeys = allHosts;
  "syncthing-key-nixos-desktop.age".publicKeys = allHosts;

  # Purchased fonts (as encrypted ZIPs).
  # These are binary, so rekey them with `agenix -r` (which re-encrypts in place without an editor).
  # Don't use `-e`, which would open the blob in $EDITOR and corrupt it.
  "fonts/MonoLisa-Plus-2.016.zip.age".publicKeys = allHosts;
  "fonts/MonoLisa-Cursive-2.016.zip.age".publicKeys = allHosts;
  "fonts/Comic-Code-Coding-Essentials-Ligatures.zip.age".publicKeys = allHosts;
}
