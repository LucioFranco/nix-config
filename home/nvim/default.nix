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
      fidget-nvim
      nvim-web-devicons

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
          rev = "34c2245a6ddfd85766f6127768f6b04b0ae2f84a";
          hash = "sha256-f6/OLa0RvDWByktwTyeLpe3p9BNlgzNHjcFHUNVQJq4=";
        };
      })

      (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
        pname = "smart-splits.nvim";
        version = "2023-04-20";
        src = pkgs.fetchFromGitHub {
          owner = "mrjones2014";
          repo = "smart-splits.nvim";
          rev = "04a075670bbe3bee6616472e2ae5cf3aa61c3eeb";
          hash = "sha256-l8oKTnL8LCuQ9SY0XuFsaPgpme3a/OpxaPSjO7yYdrU=";
        };

        dependencies = [ pkgs.luajitPackages.luacheck ];
      })
    ];
  };
}
