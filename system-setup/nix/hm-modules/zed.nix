{
  config,
  lib,
  ...
}:

let
  cfg = config.dotfiles.zed;
in
{
  options.dotfiles.zed = {
    enable = lib.mkEnableOption "Enable Zed with dotfiles defaults";
  };

  # TODO: Make use of the default Zed home-manager module: https://mynixos.com/home-manager/options/programs.zed-editor
  config = lib.mkIf cfg.enable {
    # NOTE: mkOutOfStoreSymlink requires the source path to be fixed and absolute
    # TODO: utilise the home manager built-in variable to point to the user's home directory
    # then combine with the location of dotfiles (or find a better solution/function)
    xdg.configFile."zed/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "/Users/murtadha/.dotfiles/Applications/zed/settings.json";
  };
}
