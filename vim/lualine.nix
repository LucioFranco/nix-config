{ lib, ... }:
{
  plugins = {
    navic = {
      enable = true;
      settings.lsp.auto_attach = true;
    };
    lualine =
      let
        filetype = {
          __unkeyed-1 = "filetype";
          icon_only = true;
        };
        filename = {
          __unkeyed-1 = "filename";
          symbols = {
            modified = "●";
            readonly = "🔒";
            unnamed = "[No Name]";
            newfile = "[New]";
          };
        };
        diff = {
          __unkeyed-1 = "diff";
          symbols = {
            added = " ";
            modified = " ";
            removed = " ";
          };
        };
        diagnostics = {
          __unkeyed-1 = "diagnostics";
          sources = [ "nvim_lsp" ];
          symbols = {
            error = " ";
            warn = " ";
            info = " ";
            hint = " ";
          };
        };
      in
      {
        enable = true;
        luaConfig.pre = ''
          local colors = {
            base04 = '#002731',
            base03 = '#002b36',
            base02 = '#073642',
            base01 = '#586E75',
            base00 = '#657B83',
            base0 = '#839496',
            base1 = '#93A1A1',
            base2 = '#EEE8D5',
            base3 = '#FDF6E3',
            base4 = '#fbf3db',
            blue = '#268BD2',
            cyan = '#2AA198',
            orange = '#CB4B16',
            red = '#DC322F',
            violet = '#6C71C4',
            yellow = '#B58900',
            green = '#859900',
            magenta = '#D33682',
            diag_error = '#DC322F',
            diag_hint = '#268BD2',
            diag_info = '#268BD2',
            diag_ok = '#859900',
            diag_warning = '#B58900',
            git_add = '#859900',
            git_delete = '#DC322F',
            git_modify = '#B58900',
            mix_blue = '#e7ebe1',
            mix_cyan = '#e7eddb',
            mix_green = '#f1eccc',
            mix_magenta = '#f8e2d9',
            mix_orange = '#f8e4ce',
            mix_base1 = '#2C4E56',
            mix_base01 = '#CCCDC2',
            mix_red = '#f9e2d1',
            mix_violet = '#eee8df',
            mix_yellow = '#f5ebcc',
          }
          local foreground = colors.base2

          -- if vim.o.background == 'light' then
          foreground = colors.base02
          -- end

          local custom_theme = {
            normal = {
              a = { fg = colors.base04, bg = colors.base1 },
              b = { fg = foreground, bg = colors.base1 },
              c = { fg = colors.base2, bg = colors.base2 },
            },
            insert = {
              a = { fg = colors.base04, bg = colors.base2 },
            },
            visual = {
              a = { fg = colors.base04, bg = colors.base2 },
            },
            replace = {
              a = { fg = colors.base04, bg = colors.red },
            },
            command = {
              a = { fg = colors.base03, bg = colors.red },
            },
            inactive = {
              a = { fg = foreground, bg = colors.base1 },
              b = { fg = colors.base2, bg = colors.base1 },
              c = { fg = colors.base04, bg = colors.base2 },
            },
          }
        '';
        settings = {
          inactive_sections = {
            lualine_a = [ ];
            lualine_b = [ ];
            lualine_c = [
              filetype
              filename
            ];
            lualine_x = [ "location" ];
            lualine_y = [ ];
            lualine_z = [ ];
          };
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [
              filetype
              filename
              "navic"
            ];
            lualine_c = [
              diagnostics
            ];
            lualine_x = [
              "searchcount"
              diff
              "branch"
            ];
            lualine_y = [
              "encoding"
              "fileformat"
            ];
            lualine_z = [
              "location"
              "progress"
            ];
          };
          options = {
            theme = lib.nixvim.mkRaw "custom_theme";
            section_separators = {
              left = "";
              right = "";
            };
            component_separators = {
              left = "";
              right = "";
            };
          };
          extensions = [ ];
        };
      };
  };
}
