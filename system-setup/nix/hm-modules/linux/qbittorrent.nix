{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.qbittorrent;
in
{
  options.dotfiles.qbittorrent = {
    enable = lib.mkEnableOption "qBittorrent with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      qbittorrent
    ];

    xdg.configFile."autostart/qbittorrent.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=qBittorrent
      Exec=${pkgs.qbittorrent}/bin/qbittorrent
      Terminal=false
      StartupNotify=false
    '';
  };
}
