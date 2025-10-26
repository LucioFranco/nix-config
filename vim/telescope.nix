{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    telescope-github-nvim
    telescope-git-conflicts-nvim
    telescope-manix
    cheatsheet-nvim
  ];

  extraPackages = with pkgs; [
    manix
  ];

  plugins.telescope = {
    enable = true;

    extensions = {
      file-browser = {
        enable = true;
        settings.hijack_netrw = false;
      };
      frecency = {
        enable = true;
        settings.db_safe_mode = false;
      };

      ui-select.enable = true;
      undo.enable = true;
    };

    enabledExtensions = [
      "gh"
      "conflicts"
      "manix"
    ];

    settings.pickers.colorscheme.enable_preview = true;

    #   luaConfig.post = ''
    #   -- make it globally available
    #   function jj_files()
    #     require("telescope.builtin").find_files {
    #       prompt_title = "jj Files",
    #       find_command = { "jj", "file", "list", "--no-pager" },
    #     }
    #   end
    # '';

    keymaps = {
      "<C-p>" = {
        action = "git_files";
        options.desc = "Open file search";

      };
      "<leader>fb" = {
        action = "buffers";
        options.desc = "Lists open buffers in current neovim instance";
      };
      "<leader>fc" = {
        action = "current_buffer_fuzzy_find";
        options.desc = "Live fuzzy search inside of the currently open buffer";
      };
      "<leader>ff" = {
        action = "frecency";
        options.desc = "Search for files";
      };
      "<leader>fl" = {
        action = "live_grep";
        options.desc = "Search for a string and get results live as you type";
      };
      "<leader>fg" = {
        action = "git_files";
        options.desc = "Fuzzy search for files tracked by Git";
      };
      "<leader>gc" = {
        action = "git_commits";
        options.desc = "List commits for current directory with diff preview";
      };
      "<leader>gb" = {
        action = "git_bcommits";
        options.desc = "List commits for current buffer with diff preview";
      };
      "<leader>gs" = {
        action = "git_status";
        options.desc = "List git status for current directory";
      };
      "<leader>u" = {
        action = "undo";
        options.desc = "List undo history";
      };
    };
  };
}
