# Reference: https://github.com/Veraticus/nix-config/blob/main/home-manager/claude-code/default.nix

{ pkgs, ... }:
{

  home.packages = [ pkgs.claude-code ];

  # Create and manage ~/.claude directory
  home.file.".claude/settings.json".source = ./settings.json;
  home.file.".claude/CLAUDE.md".source = ./root-claude.md;
}
