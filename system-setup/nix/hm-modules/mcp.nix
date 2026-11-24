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
        # for learning about Rex, for seeing what’s new or coming, and for finding the thinking behind decisions
        # that is buried in archived threads. Uses Discord OAuth + requires Rex Beta Discord server membership.
        # Named superlogical rather than rex, so it doesn’t conflict with Rex skills, instructions, and the CLI.
        superlogical.url = "https://www.superlogical.com/rex/community-mcp";
      };
    };
  };
}
