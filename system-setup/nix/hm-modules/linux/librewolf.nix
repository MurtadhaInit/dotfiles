{
  config,
  lib,
  ...
}:

let
  cfg = config.dotfiles.librewolf;
in
{
  options.dotfiles.librewolf = {
    enable = lib.mkEnableOption "Enable Librewolf with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
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
  };
}
