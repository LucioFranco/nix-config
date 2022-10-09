{ pkgs, ... }: {
  home = {
    sessionVariables = rec {
      EDITOR = "nvim";
      VISUAL = EDITOR;
    };
    shellAliases = { vi = "nvim"; vim = "nvim"; };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;

    extraConfig = builtins.readFile ./init.vim;

    plugins = with pkgs.vimPlugins; [
      # LSP
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-vsnip
      cmp-path
      cmp-buffer

      # Rust
      rust-tools-nvim

      vim-vsnip
      popup-nvim
      plenary-nvim
      telescope-nvim

      editorconfig-vim
      vim-nix
      vim-polyglot

      fzf-vim

      # UI
      vim-gitgutter
      vim-fugitive

      # Theme: Solarized light
      (pkgs.vimUtils.buildVimPlugin rec {
        pname = "solarized-nvim";
        version = "07-08-2022";
        src = pkgs.fetchFromGitHub {
          owner = "shaunsingh";
          repo = "solarized.nvim";
          rev = "34c2245a6ddfd85766f6127768f6b04b0ae2f84a";
          sha256 = "f6/OLa0RvDWByktwTyeLpe3p9BNlgzNHjcFHUNVQJq4=";
        };
      })
    ];
  };
}
