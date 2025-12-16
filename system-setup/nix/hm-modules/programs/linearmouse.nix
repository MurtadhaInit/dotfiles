{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    linearmouse.enable = lib.mkEnableOption "Configure LinearMouse (macOS)";
  };

  config = lib.mkIf config.linearmouse.enable {
    # NOTE: mkOutOfStoreSymlink requires the source path to be fixed and absolute
    # TODO: utilise the home manager built-in variable to point to the user's home directory
    # then combine with the location of dotfiles (or find a better solution/function)
    xdg.configFile."linearmouse/linearmouse.json".source =
      config.lib.file.mkOutOfStoreSymlink "/Users/murtadha/.dotfiles/Applications/linearmouse/linearmouse.json";
  };
}
