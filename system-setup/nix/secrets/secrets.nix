let
  # Age public key for the macOS machine
  # Get with: age-keygen -y ~/.ssh/keys/age.txt
  macbook = "age1fjfzlw6ah4k3kh07ray363e87rt6z8rfhljjxprwhqa7y0pw9vjqvv0f9h";
in
{
  # Edit with (in this dir): nix run github:ryantm/agenix -- -e <filename>.age
  # Re-encrypt from a file (Nushell): open <filename.key> | nix run github:ryantm/agenix -- -e <filename>.age

  "syncthing-gui-password.age".publicKeys = [ macbook ];
  # Generate a key pair with: nix run nixpkgs#syncthing -- generate --config ./conf --data ./data
  # Then (Nushell): open ./conf/cert.pem | nix run github:ryantm/agenix -- -e syncthing-cert.age
  # And: open ./conf/key.pem | nix run github:ryantm/agenix -- -e syncthing-key.age
  # Obtain device ID with: nix run nixpkgs#syncthing -- device-id --config ./conf --data ./data
  "syncthing-key.age".publicKeys = [ macbook ];
  "syncthing-cert.age".publicKeys = [ macbook ];
}
