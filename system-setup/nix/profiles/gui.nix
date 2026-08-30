# Desktop applications: anything needing a display server or a login session.
# A headless host simply omits this profile.
{ pkgs, lib, ... }:

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

  # mkDefault so a host can opt out of any single app with a plain `false`, and so
  # the platform switches below stay overridable too.
  dotfiles = {
    ghostty.enable = lib.mkDefault true;
    jetbrains.enable = lib.mkDefault true;
    vscode.enable = lib.mkDefault true;
    zed.enable = lib.mkDefault true;

    linearmouse.enable = lib.mkDefault isDarwin;
    tuna.enable = lib.mkDefault isDarwin;

    brave.enable = lib.mkDefault isLinux;
    tailscale-systray.enable = lib.mkDefault isLinux;
  };
}
