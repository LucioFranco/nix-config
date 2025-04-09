" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Default tab settings
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set relativenumber
set number

set textwidth=80

" Theme settings
syntax enable
set background=light
colorscheme solarized
"colorscheme jellybeans
"
"" Treat :W as :w for when typos happen
command! W w
command! Wa wa

let mapleader="\<Space>"
nnoremap <leader>v :vsplit<CR>

" Ctrl-p with fzf
nnoremap <C-p> :Files<Cr>

" Nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Allow esc to be used in term mode
tnoremap <Esc> <C-\><C-n>

set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()


local nvim_lsp = require'lspconfig'
nvim_lsp.nixd.setup({})
nvim_lsp.pyright.setup({
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic"
      }
    }     
  }
})

nvim_lsp.gopls.setup{}
nvim_lsp.zls.setup{}

local navic = require("nvim-navic")

local opts = {
    tools = { -- rust-tools options
        --autoSetHints = true,
        reload_workspace_from_cargo_toml = true,
        --hover_with_actions = true,
        inlay_hints = {
            auto = false,
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        on_attach = function(client, bufnr)
          navic.attach(client, bufnr)
        end,
        capabilities=capabilities,
        cmd = { os.getenv("HOME") .."/.cargo/bin/rust-analyzer" },
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                
                diagnostics = {
                  enable = false,
                },
                completion = {
                  privateEditable = {
                    enable = true;
                  },
                },
                cargo = {
                    features = "all"
                }
            }
        }
    },
}


--require('rust-tools').setup(opts)
vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
    enable_clippy = false,
  },
  -- LSP configuration
  server = {
    cmd = { os.getenv("HOME") .."/.cargo/bin/rust-analyzer" },
    on_attach = function(client, bufnr)
      -- you can also put keymaps in here
    end,
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
        diagnostics = {
          enable = false,
        },
        completion = {
          privateEditable = {
            enable = true;
          },
        },
        cargo = {
            --features = "all"
        }
      },
    },
  },
  -- DAP configuration
  dap = {
  },
}

local neotest = require("neotest")
neotest.setup({
  adapters = {
    require("neotest-plenary"),
    require('rustaceanvim.neotest')  
  },
})

local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  "n", 
  "<leader>a", 
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr }
)
vim.keymap.set(
  "n", 
  "K",  -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function()
    vim.cmd.RustLsp({'hover', 'actions'})
  end,
  { silent = true, buffer = bufnr }
)

vim.keymap.set(
  "n", 
  "<leader>rr",
  function()
    vim.cmd.RustLsp('runnables')
  end,
  { silent = true, noremap = true }
)

vim.keymap.set(
  "n", 
  "<leader>rt",
  function()
    vim.cmd.RustLsp('testables')
  end,
  { silent = true, noremap = true }
)

vim.keymap.set(
  "n", 
  "<leader>to",
  function()
    neotest.output.open({ enter = true }) 
  end,
  { silent = true, noremap = true }
)
vim.keymap.set(
  "n", 
  "<leader>tp",
  function()
    neotest.output_panel.toggle() 
  end,
  { silent = true, noremap = true }
)




require('trouble').setup({})

require('dressing').setup({
  input = {
    enabled = true,
  },
  select = {
    enabled = true,
  },
})

require('nvim-web-devicons').setup({})

require("lsp_lines").setup()

-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
})

vim.keymap.set(
  "",
  "<Leader>l",
  require("lsp_lines").toggle,
  { desc = "Toggle lsp_lines" }
)

require('smart-splits').setup({})

-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
-- moving between splits
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
-- swapping buffers between windows
vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)

-- require('zellij').setup({
--           vimTmuxNavigatorKeybinds = true,
--         })


require('lualine').setup({
    sections = {
      lualine_c = {
        'lsp_progress', { "filename", path = 1 }
      } 
    }
})

-- require("copilot").setup({
--   suggestion = { enabled = false },
--   panel = { enabled = false },
-- })
-- require("copilot_cmp").setup()

-- require("harpoon").setup({})

require('avante_lib').load()
require('avante').setup ({
  -- Your config here!
})

vim.keymap.set('n', '<leader>ht', require('harpoon.ui').toggle_quick_menu)
vim.keymap.set('n', '<leader>ha', require('harpoon.mark').add_file)
for i = 1, 9 do
  vim.keymap.set( 
    'n',
    string.format("<leader>h%s", i),
    function()
      require("harpoon.ui").nav_file(i)
    end
  ) 
end
EOF

" Set format on save
autocmd BufWritePre * lua vim.lsp.buf.format(nil, 200)

" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> <c-K> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
"nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gR    <cmd>lua vim.lsp.buf.rename()<CR>
"nnoremap <silent> grr   <cmd>RustRunnables<CR>

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

" Trouble keybinds
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>Trouble workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>Trouble document_diagnostics<cr>
nnoremap <leader>xq <cmd>Trouble quickfix<cr>
nnoremap <leader>xl <cmd>Trouble loclist<cr>
nnoremap xR <cmd>Trouble lsp_references<cr>

" setup mapping to call :LazyGit
nnoremap <silent> <leader>gg :LazyGit<CR>



