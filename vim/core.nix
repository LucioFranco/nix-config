{ lib, ... }:
{
  autoCmd = [
    {
      desc = "auto read when a file is changed from the outside";
      command = "checktime";
      event = [
        "BufEnter"
        "CursorHold"
        "FocusGained"
        "TermClose"
        "TermLeave"
        "VimResume"
      ];
    }
    {
      desc = "return to last edit position when opening files";
      event = [ "BufRead" ];
      callback = lib.nixvim.mkRaw ''
        function(opts)
          vim.api.nvim_create_autocmd('BufWinEnter', {
            once = true,
            buffer = opts.buf,
            callback = function()
              local ft = vim.bo[opts.buf].filetype
              local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
              if
                not (ft:match('commit') and ft:match('rebase'))
                and last_known_line > 1
                and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
              then
                vim.api.nvim_feedkeys([[g`"]], 'nx', false)
              end
            end,
          })
        end
      '';
    }
  ];

  keymaps = [
    {
      action = ":vsplit<cr>";
      key = "<leader>bv";
      options.desc = "Vertical split buffer";
    }
    {
      action = ":nohl<cr>";
      key = "<leader><cr>";
      options.desc = "Disable search highlighting";
    }
    {
      action = ":enew<cr>";
      key = "<leader>bn";
      options.desc = "Create a new buffer in the current window";
    }
    {
      action = ":bdelete<cr>";
      key = "<leader>bd";
      options.desc = "Close the current buffer";
    }
    {
      action = ":bufdo bd<cr>";
      key = "<leader>ba";
      options.desc = "Close all buffers";
    }
    {
      action = ":bnext<cr>";
      key = "<leader>l";
      options.desc = "Go to next buffer";
    }
    {
      action = ":bprevious<cr>";
      key = "<leader>h";
      options.desc = "Go to previous buffer";
    }
    {
      action = ":tabnew<cr>";
      key = "<leader>tn";
      options.desc = "Create a new tab";
    }
    {
      action = ":tabonly<cr>";
      key = "<leader>to";
      options.desc = "Close all other tabs";
    }
    {
      action = ":tabclose<cr>";
      key = "<leader>to";
      options.desc = "Close the current tab";
    }
    {
      action = ":tabmove";
      key = "<leader>tm";
      options.desc = "Move the current tab";
    }
    {
      action = ":cd %:p:h<cr>:pwd<cr>";
      key = "<leader>cd";
      options.desc = "Set CWD to the directory of the current buffer";
    }
  ];

  clipboard.register = "unnamedplus";

  opts = {
    background = "light";

    colorcolumn = "120";
    history = 500;
    autoread = true;
    signcolumn = "yes";
    number = true;
    relativenumber = true;
    cursorline = true;
    scrolloff = 10;
    undofile = true;
    ignorecase = true;
    smartcase = true;
    splitkeep = "screen";
    termguicolors = true;
    fileformats = "unix,dos,mac";
    # Time in milliseconds to wait for a mapped sequence to complete,
    # see https://unix.stackexchange.com/q/36882/221410 for more info
    timeoutlen = 500;
    updatetime = 250; # For CursorHold events
    swapfile = false;

    # Tab settings
    tabstop = 4;
    softtabstop = 4;
    shiftwidth = 4;
    expandtab = true;
    linebreak = true;
    mouse = "nv";
    spelllang = "eu_us";

    wrap = false;
    sidescroll = 1;
    listchars = "extends:>,precedes:<";
    sidescrolloff = 1;
  };

  globals = {
    # Unused providers
    loaded_node_provider = 0;
    loaded_perl_provider = 0;
    loaded_ruby_provider = 0;
    mapleader = " "; # Custom mapping <leader> (see `:h mapleader` for more info)
    vimsyn_embed = "l"; # Enable highlighting for lua HERE doc inside vim script
    # Do not use builtin matchit.vim and matchparen.vim since we use vim-matchup
    loaded_matchit = 1;
    loaded_matchparen = 1;
    loaded_sql_completion = 1; # Disable sql omni completion, it is broken.
  };
}
