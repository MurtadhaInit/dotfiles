{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.tailscale-systray;
in
{
  options.dotfiles.tailscale-systray = {
    enable = lib.mkEnableOption "Tailscale systray applet (autostart in graphical sessions)";
  };

  config = lib.mkIf cfg.enable {
    # Docs: https://tailscale.com/docs/features/client/linux-systray
    # This is the declarative stand-in for `tailscale configure systray --enable-startup=freedesktop`.
    # The tailscale CLI is installed system-wide by services.tailscale (NixOS module).
    # The tray runs as your user; `--operator=murtadha` is what lets it control tailscaled without root.
    # With useGlobalPkgs, ${pkgs.tailscale} is the same build as the running daemon.

    xdg.configFile."autostart/tailscale-systray.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Tailscale System Tray
      Exec=${pkgs.tailscale}/bin/tailscale systray
      Terminal=false
      StartupNotify=false
    '';

    # The tray's "copy to clipboard" actions shell out to a clipboard utility.
    home.packages = [ pkgs.wl-clipboard ];
  };
}
