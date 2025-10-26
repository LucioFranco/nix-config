{ pkgs, ... }:
{
  home = {
    sessionVariables = rec {
      EDITOR = "nvim";
      VISUAL = EDITOR;
    };
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };

  home.packages = with pkgs; [ lucio-neovim ];
}
