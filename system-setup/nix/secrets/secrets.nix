let
  # Age public key for the macOS machine
  # Get with: age-keygen -y ~/.ssh/keys/age.txt
  macbook = "age1fjfzlw6ah4k3kh07ray363e87rt6z8rfhljjxprwhqa7y0pw9vjqvv0f9h";
in
{
  # Edit with (in this dir): nix run github:ryantm/agenix -- -e syncthing-gui-password.age
  "syncthing-gui-password.age".publicKeys = [ macbook ];
}
