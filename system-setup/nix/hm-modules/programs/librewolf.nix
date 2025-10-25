{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.librewolf = {
    enable = lib.mkDefault true;
    settings = {
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.downloads" = false;
      # "privacy.clearOnShutdown.cookies" = false;

      # Enable WebGL
      # "webgl.disabled" = false;
      # policies = {
      #   ExtensionSettings = {

      #   };
      # };

      # enable autoscroll (and disable pasting with middle mouse click)
      "middlemouse.paste" = false;
      "general.autoScroll" = true;
    };
  };
}
