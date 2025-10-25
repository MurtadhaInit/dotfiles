{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.chromium = {
    enable = lib.mkDefault true;
    package = pkgs.brave;
    nativeMessagingHosts = [
      pkgs.kdePackages.plasma-browser-integration
    ];
  };
}
