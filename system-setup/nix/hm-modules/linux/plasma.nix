{
  config,
  lib,
  inputs,
  ...
}:

let
  cfg = config.dotfiles.plasma;
in
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  options.dotfiles.plasma = {
    enable = lib.mkEnableOption "KDE Plasma settings managed declaratively via plasma-manager";
    wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Wallpaper image applied to all desktops and the lock screen on login";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.plasma = {
      enable = true;

      # Additive only: leave settings tweaked via System Settings untouched.
      # TODO: flip to true after capturing current settings = plasma-manager owns the
      # whole Plasma config and wipes anything not declared in Nix.
      overrideConfig = false;

      # Reopen whatever apps were running at logout/shutdown on the next login
      configFile.ksmserverrc.General.loginMode = "restorePreviousLogout";

      # Wallpaper is applied by a plasma-manager startup script, so it takes
      # effect on the next login rather than at activation time
      workspace.wallpaper = lib.mkIf (cfg.wallpaper != null) cfg.wallpaper;
      # Same image on the lock screen
      kscreenlocker.appearance.wallpaper = lib.mkIf (cfg.wallpaper != null) cfg.wallpaper;

      # US + Arabic keyboard layouts for the desktop session (toggle with Super+Space)
      input.keyboard = {
        layouts = [
          {
            layout = "us";
            displayName = "en";
          }
          {
            layout = "ara";
            displayName = "ar";
          }
        ];
        options = [ "grp:win_space_toggle" ];
        switchingPolicy = "global"; # same layout across all windows; "window" for per-app memory
      };

      # Let KWin own the geometry for Ghostty: every Ghostty window opens maximized
      # window-rules = [
      #   {
      #     description = "Ghostty — open maximized";
      #     match = {
      #       window-class = {
      #         value = "com.mitchellh.ghostty";
      #         type = "substring";
      #       };
      #       window-types = [ "normal" ];
      #     };
      #     apply = {
      #       maximizehoriz = true;
      #       maximizevert = true;
      #     };
      #   }
      # ];
    };
  };
}
