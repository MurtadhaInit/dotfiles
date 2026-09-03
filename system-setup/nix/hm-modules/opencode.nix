{
  config,
  lib,
  ...
}:

let
  cfg = config.dotfiles.opencode;
in
{
  imports = [ ./common.nix ];

  options.dotfiles.opencode = {
    enable = lib.mkEnableOption "OpenCode with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "opencode/opencode.jsonc".source =
        config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.repoPath}/Applications/opencode/opencode.jsonc";
      "opencode/tui.jsonc".source =
        config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.repoPath}/Applications/opencode/tui.jsonc";
    };
  };
}
