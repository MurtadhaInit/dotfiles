{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.qbittorrent ];

  # for incoming peer connections (matches the port set in the app)
  networking.firewall.allowedTCPPorts = [ 15522 ];

  environment.etc."xdg/autostart/qbittorrent.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=qBittorrent
    Exec=${pkgs.qbittorrent}/bin/qbittorrent
    Terminal=false
    StartupNotify=false
  '';
}
