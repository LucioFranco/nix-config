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

      # Environment variables for better performance
      env = {
        DISABLE_NON_ESSENTIAL_MODEL_CALLS = "1";
        DISABLE_TELEMETRY = "1";
        MAX_MCP_OUTPUT_TOKENS = "50000";
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
      };
    };

    # MCP Servers
    # mcpServers = {
    #   serena = {
    #     command = "nix";
    #     type = "stdio";
    #     args = [
    #       "run"
    #       "github:oraios/serena"
    #       "--"
    #       "start-mcp-server"
    #       "--transport"
    #       "stdio"
    #       "--enable-web-dashboard"
    #       "false"
    #     ];
    #   };
    #
    #   # spec-workflow = {
    #   #   command = "npx";
    #   #   type = "stdio";
    #   #   args = [
    #   #     "-y"
    #   #     "@pimzino/spec-workflow-mcp@latest"
    #   #     "--AutoStartDashboard"
    #   #   ];
    #   # };
    #
    #   # sequential-thinking = {
    #   #   command = "npx";
    #   #   type = "stdio";
    #   #   args = [
    #   #     "-y"
    #   #     "@modelcontextprotocol/server-sequential-thinking"
    #   #   ];
    #   # };
    # };
  };
}
