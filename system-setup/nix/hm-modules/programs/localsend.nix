{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    localsend.enable = lib.mkEnableOption "Install and configure Localsend";
  };

  config = lib.mkIf config.localsend.enable {
    home.packages = with pkgs; [
      localsend
    ];

    xdg.configFile."autostart/localsend_app.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=localsend_app
      Comment=localsend_app startup script
      Exec=localsend_app --hidden
      StartupNotify=false
      Terminal=false
    '';
  };
}
