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
    # Only for the MCP servers from mcp.nix, which HM writes to opencode.json. OpenCode
    # merges that with the hand-written opencode.jsonc (the latter wins on conflicts).
    programs.opencode = {
      enable = true;
      package = null;
      enableMcpIntegration = true;
    };

    xdg.configFile = {
      "opencode/opencode.jsonc".source =
        config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.repoPath}/Applications/opencode/opencode.jsonc";
      "opencode/tui.jsonc".source =
        config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.repoPath}/Applications/opencode/tui.jsonc";
    };
  };
}
