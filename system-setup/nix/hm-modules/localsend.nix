{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.localsend;
in
{
  options.dotfiles.localsend = {
    enable = lib.mkEnableOption "Enable LocalSend with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
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
