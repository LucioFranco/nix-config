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
      nerdtree

      vim-commentary

      # Diagnostics
      dressing-nvim
      trouble-nvim
      nvim-web-devicons

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

      # tmux
      # There seems to be some sort of bug with this plugin
      # so pin it to the last working version.
      # (pkgs.vimUtils.buildVimPlugin rec {
      #   pname = "vim-tmux-navigator";
      #   version = "2022-10-15";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "christoomey";
      #     repo = "vim-tmux-navigator";
      #     rev = "bd4c38be5b4882991494cf77c0601a55bc45eebf";
      #     sha256 = "17yqy79p5i54wkg1wmb32v84s05rfaywx7qzayzs5q485zap4813";
      #   };
      # })

      # Theme: Solarized light
      jellybeans-vim
      (pkgs.vimUtils.buildVimPlugin rec {
        pname = "solarized-nvim";
        version = "07-08-2022";
        src = pkgs.fetchFromGitHub {
          owner = "shaunsingh";
          repo = "solarized.nvim";
          rev = "fe02ed49cc017cc93657bd6306a2624394611c69";
          hash = "sha256-f6/OLa0RvDWByktwTyeLpe3p9BNlgzNHjcFHUNVQJq4=";
        };
      })

      (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
        pname = "smart-splits.nvim";
        version = "2023-04-20";
        src = pkgs.fetchFromGitHub {
          owner = "mrjones2014";
          repo = "smart-splits.nvim";
          rev = "ecea65d8f029978d92e29f5fa83f6774f31249aa";
          hash = "sha256-mLLh8rcq5D6dA9Iwn3ULiHRG/jI4Sjct4J498C+QPO8=";
        };

        dependencies = [ pkgs.luajitPackages.luacheck ];
      })

      # (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
      #   pname = "zellij.nvim";
      #   version = "2023-07-25";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "Lilja";
      #     repo = "zellij.nvim";
      #     rev = "ab2a2d7adf4779f99bbdd514f19a64c3abb910eb";
      #     hash = "sha256-gR6INhtPErNGkd5wnomvHXnGhRI/AkmMFfhM6jmrVrM=";
      #   };
      # })
    ];
  };
}
