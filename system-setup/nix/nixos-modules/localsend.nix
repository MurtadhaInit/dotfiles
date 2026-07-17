{ config, ... }:

{
  programs.localsend.enable = true;
  # openFirewall = true by default; opens both TCP & UDP ports of 53317

  # System-wide autostart entry pointing at the same package the module installs
  environment.etc."xdg/autostart/localsend_app.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=LocalSend
    Exec=${config.programs.localsend.package}/bin/localsend_app --hidden
    Terminal=false
    StartupNotify=false
  '';
}
