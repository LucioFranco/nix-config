{ ... }:
{
  programs.claude-code = {
    enable = true;

    # Memory/context file
    memory.source = ./root-claude.md;

    # Model and environment settings
    settings = {
      # Auto-approve all project MCP servers
      enableAllProjectMcpServers = true;

      # Tool permissions - allow all MCP tools
      permissions = {
        allow = [
          # Core editing tools
          "Task"
          "Read"
          "Edit"
          "MultiEdit"
          "Write"
          "Glob"
          "Grep"
          "LS"

          # Bash commands (scoped for safety)
          "Bash(git :*)"
          "Bash(jj :*)"
          "Bash(nix :*)"
          "Bash(cargo :*)"
          "Bash(npm :*)"
          "Bash(linctl :*)"

          # Web tools
          "WebFetch"
          "WebSearch"

          # Allow default installed mcp tools
          "mcp__serena"
          "mcp__sequential-thinking"
          "mcp__moose-dev"
        ];

        deny = [
          # Protect sensitive files
          "Read(./.env)"
          "Read(./.env.*)"
          "Read(./secrets/**)"
          "Read(**/credentials.json)"
          "Bash(rm -rf :*)"
          "Bash(sudo :*)"
        ];
      };

      enabledPlugins = {
        "superpowers@superpowers-marketplace" = true;
      };

      model = "claude-opus-4-5-20251101";

      # Environment variables for better performance
      env = {
        DISABLE_TELEMETRY = "1";
        ENABLE_TOOL_SEARCH = "true";
      };
    };
  };
}
