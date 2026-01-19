{
  config,
  pkgs,
  lib,
  ...
}:

{
  # TODO: Make use of the default Zed home-manager module: https://mynixos.com/home-manager/options/programs.zed-editor
  options = {
    zed.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Configure the Zed editor.
      '';
    };
  };

  config = lib.mkIf config.zed.enable {
    # NOTE: mkOutOfStoreSymlink requires the source path to be fixed and absolute
    # TODO: utilise the home manager built-in variable to point to the user's home directory
    # then combine with the location of dotfiles (or find a better solution/function)
    xdg.configFile."zed/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "/Users/murtadha/.dotfiles/Applications/zed/settings.json";
  };
}
