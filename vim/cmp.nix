{ lib, ... }:
{
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        appearance.use_nvim_cmp_as_default = true;
        completion = {
          list.selection.preselect = false;
          documentation = {
            auto_show = true;
            window.border = "rounded";
          };
          ghost_text.enabled = true;
        };
        signature = {
          enabled = true;
          window.border = "rounded";
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "tmux"
          ];
          providers = {
            lsp.score_offset = 3;
            path.score_offset = 2;
            snippets.score_offset = 2;
            buffer.score_offset = 1;
            tmux = {
              name = "tmux";
              module = "blink.compat.source";
              score_offset = 0;
            };
            # Only enable cmp in everything that isn't `!`
            # Ref: https://cmp.saghen.dev/recipes.html#disable-completion-in-only-shell-command-mode
            cmdline = {
              enabled = lib.nixvim.mkRaw ''
                function()
                  return vim.fn.getcmdtype() ~= ':' or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
                end
              '';

            };
          };
        };
        keymap = {
          preset = "enter";
          "<C-n>" = [
            "select_next"
            "fallback"
          ];
          "<C-p>" = [
            "select_prev"
            "fallback"
          ];
          "<Tab>" = [
            "snippet_forward"
            "fallback"
          ];
          "<S-Tab>" = [
            "snippet_backward"
            "fallback"
          ];
        };
      };
    };
    cmp-tmux.enable = true;
    blink-compat.enable = true;
    friendly-snippets.enable = true;
  };
}
