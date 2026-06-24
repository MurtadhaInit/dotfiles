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
