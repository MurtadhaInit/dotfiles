{
  config,
  lib,
  ...
}:

let
  cfg = config.dotfiles.herdr;
in
{
  options.dotfiles.herdr = {
    enable = lib.mkEnableOption "Herdr terminal multiplexer config";
  };

  # NOTE: Herdr itself is installed through Mise
  config = lib.mkIf cfg.enable {
    # Out-of-store so the file stays writable and edits apply with
    # `herdr server reload-config` instead of a rebuild.
    xdg.configFile."herdr/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/Applications/herdr/config.toml";
  };
}
