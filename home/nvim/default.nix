{ pkgs, ... }: {
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

  home.packages = with pkgs; [ lazygit ];

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
      cmp-nvim-lsp

      lsp_lines-nvim

      nvim-navic

      # Rust
      #rust-tools-nvim
      rustaceanvim

      vim-vsnip
      popup-nvim
      plenary-nvim
      telescope-nvim

      editorconfig-vim
      vim-nix
      vim-polyglot
      nvim-treesitter

      fzf-vim

      # UI
      vim-gitgutter
      vim-fugitive
      nerdtree

      vim-commentary

      # Diagnostics
      dressing-nvim
      trouble-nvim
      nvim-web-devicons

      # test
      neotest
      neotest-plenary
      FixCursorHold-nvim
      nvim-nio

      # git
      lazygit-nvim

      # statusbar
      lualine-nvim
      lualine-lsp-progress

      # copilot
      copilot-lua
      copilot-cmp

      # Buffer navigation
      plenary-nvim
      harpoon

      avante-nvim
      mini-icons
      nui-nvim

      # tmux
      smart-splits-nvim

      # Theme: Solarized light
      solarized-nvim
      jellybeans-vim
    ];
  };
}
