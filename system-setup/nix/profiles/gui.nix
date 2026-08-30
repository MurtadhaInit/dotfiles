# Desktop applications: anything needing a display server or a login session.
# A headless host simply omits this profile.
{ pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in
{
  imports = [
    # Cross-platform
    ../hm-modules/ghostty.nix
    ../hm-modules/jetbrains.nix
    ../hm-modules/vscode.nix
    ../hm-modules/zed.nix

    # macOS
    ../hm-modules/macos/linearmouse.nix
    ../hm-modules/macos/tuna.nix

    # Linux
    ../hm-modules/linux/brave.nix
    ../hm-modules/linux/tailscale-systray.nix
  ];

  dotfiles = {
    ghostty.enable = true;
    jetbrains.enable = true;
    vscode.enable = true;
    zed.enable = true;

    linearmouse.enable = isDarwin;
    tuna.enable = isDarwin;

    brave.enable = isLinux;
    tailscale-systray.enable = isLinux;
  };
}
