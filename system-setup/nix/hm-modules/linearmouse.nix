{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.linearmouse;
in
{
  options.dotfiles.linearmouse = {
    enable = lib.mkEnableOption "Enable Librewolf with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    # NOTE: mkOutOfStoreSymlink requires the source path to be fixed and absolute
    # TODO: utilise the home manager built-in variable to point to the user's home directory
    # then combine with the location of dotfiles (or find a better solution/function)
    xdg.configFile."linearmouse/linearmouse.json".source =
      config.lib.file.mkOutOfStoreSymlink "/Users/murtadha/.dotfiles/Applications/linearmouse/linearmouse.json";
  };
}
