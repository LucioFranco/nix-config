{
  pkgs,
  lib,
  ...
}:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "zellij-nav.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "swaits";
        repo = "zellij-nav.nvim";
        rev = "91cc2a642d8927ebde50ced5bf71ba470a0fc116";
        sha256 = "sha256-OoxvSmZV6MCYKrH2ijGqIYhdSZG5oaRj+NFJGt0viyk=";
      };
    })
  ];

  keymaps = [
    {
      mode = "n";
      key = "<C-h>";
      action = lib.nixvim.mkRaw "require('zellij-nav').left_tab";
      options = {
        silent = true;
        desc = "Navigate left (Neovim/Zellij)";
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = lib.nixvim.mkRaw "require('zellij-nav').down";
      options = {
        silent = true;
        desc = "Navigate down (Neovim/Zellij)";
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = lib.nixvim.mkRaw "require('zellij-nav').up";
      options = {
        silent = true;
        desc = "Navigate up (Neovim/Zellij)";
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = lib.nixvim.mkRaw "require('zellij-nav').right_tab";
      options = {
        silent = true;
        desc = "Navigate right (Neovim/Zellij)";
      };
    }
  ];

  autoCmd = [
    {
      event = "VimLeave";
      callback = lib.nixvim.mkRaw ''
        function()
          vim.fn.system("zellij action switch-mode normal")
        end
      '';
      desc = "Switch Zellij back to normal mode on exit";
    }
  ];
}
