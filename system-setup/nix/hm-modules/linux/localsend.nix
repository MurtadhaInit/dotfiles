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
    enable = lib.mkEnableOption "LocalSend with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      localsend
    ];

    xdg.configFile."autostart/localsend_app.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=LocalSend
      Exec=${pkgs.localsend}/bin/localsend_app --hidden
      Terminal=false
      StartupNotify=false
    '';
  };
}
