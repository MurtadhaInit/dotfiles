{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.brave;
in
{
  options.dotfiles.brave = {
    enable = lib.mkEnableOption "Enable Brave with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
      ];
    };
  };
}
