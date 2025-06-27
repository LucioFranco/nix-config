{ pkgs, ... }:
{

  home.packages = [ pkgs.claude-code ];
  # programs.claude-code = {
  # enable = true;
  # mcp = {
  #   filesystem = {
  #     enable = true;
  #     allowedPaths = [ "${config.home.homeDirectory}/code" ];
  #   };
  #   github = {
  #     enable = false;
  #   };
  #   fetch.enable = false;
  #   # lsp-rust.enable = true;
  #   # lsp-python.enable = true;
  #   # lsp-nix.enable = true;
  #   sequential-thinking.enable = true;
  #   # time.enable = true;
  # };
  # };
}
