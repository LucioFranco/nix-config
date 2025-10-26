{ lib, ... }:
{
  plugins.smart-splits = {
    enable = true;
    settings = {
      multiplexer_integration = "zellij";
      disable_multiplexer_nav_when_zoomed = false;
    };
  };

  keymaps = [
    # Resizing windows with Alt+hjkl
    {
      mode = "n";
      key = "<A-h>";
      action = lib.nixvim.mkRaw "require('smart-splits').resize_left";
      options = {
        silent = true;
        desc = "Resize window left";
      };
    }
    {
      mode = "n";
      key = "<A-j>";
      action = lib.nixvim.mkRaw "require('smart-splits').resize_down";
      options = {
        silent = true;
        desc = "Resize window down";
      };
    }
    {
      mode = "n";
      key = "<A-k>";
      action = lib.nixvim.mkRaw "require('smart-splits').resize_up";
      options = {
        silent = true;
        desc = "Resize window up";
      };
    }
    {
      mode = "n";
      key = "<A-l>";
      action = lib.nixvim.mkRaw "require('smart-splits').resize_right";
      options = {
        silent = true;
        desc = "Resize window right";
      };
    }
  ];
}
