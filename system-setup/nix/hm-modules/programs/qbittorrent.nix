{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    qbittorrent.enable = lib.mkEnableOption "Install and configure qbittorrent";
  };

  config = lib.mkIf config.qbittorrent.enable {
    home.packages = with pkgs; [
      qbittorrent
    ];

    xdg.configFile."autostart/qbittorrent.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=qBittorrent
      Comment=qBittorrent startup script
      Exec=${pkgs.qbittorrent}/bin/qbittorrent
      StartupNotify=false
      Terminal=false
    '';
  };
}
