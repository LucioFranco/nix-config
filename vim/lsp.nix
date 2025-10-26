{ lib, ... }:
{
  plugins = {
    lsp = {
      enable = true;
      inlayHints = false;
      keymaps = {
        diagnostic = {
          "[d" = "goto_prev";
          "]d" = "goto_next";
          "<leader>e" = "open_float";
        };
        lspBuf = {
          "ca" = "code_action";
          "gD" = "declaration";
          "gd" = "definition";
          "K" = "hover";
          "gi" = "implementation";
          "gr" = "references";
          "<leader>D" = "type_definition";
          "<leader>rn" = "rename";
        };

        extra = [
          {
            key = "<leader>f";
            mode = [
              "n"
              "v"
            ];
            action =
              lib.nixvim.mkRaw # lua
                ''
                  function()
                    vim.lsp.buf.format({ async = true })
                  end
                '';
            options.desc = "Format the current buffer";
          }
        ];
      };

      servers = {
        nixd = {
          enable = true;
          settings.formatting.command = [ "nixfmt" ];
        };
        pyright = {
          enable = true;

          extraOptions.settings = {
            pyright.disableOrganizeInports = true;
            python.analysis = {
              # Ignore all files for analysis to exclusively use Ruff for linting
              ignore.__raw = ''{ '*' }'';
            };
          };
        };
        ruff = {
          enable = true;
          onAttach.function = ''
            if client.name == 'ruff' then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          '';
        };

        helm_ls = {
          enable = true;
        };
      };
    };

    rustaceanvim.enable = true;
    trouble.enable = true;
    crates.enable = true;
    helm.enable = true;
  };

  keymaps = [
    {
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    {
      key = "<leader>cs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options.desc = "Symbols (Trouble)";
    }
    {
      key = "<leader>cl";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      options.desc = "LSP Definitions / references / ... (Trouble)";
    }
    {
      key = "<leader>xL";
      action = "<cmd>Trouble loclist toggle<cr>";
      options.desc = "Location List (Trouble)";
    }
    {
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<cr>";
      options.desc = "Quickfix List (Trouble)";
    }
  ];
}
