# MCP servers shared by every agent that enables Home Manager's MCP integration
# (e.g. see claude-code.nix and opencode.nix).
{
  config,
  lib,
  ...
}:

let
  cfg = config.dotfiles.mcp;
in
{
  options.dotfiles.mcp = {
    enable = lib.mkEnableOption "MCP servers shared across coding agents";
  };

  config = lib.mkIf cfg.enable {
    programs.mcp = {
      enable = true;
      servers = {
        nushell-mcp = {
          command = "nu";
          args = [ "--mcp" ];
        };
        executor.url = "https://executor.k8s.murtadha.dev/mcp?elicitation_mode=native&search_tools=true";
      };
    };
  };
}
