{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        dynamic_padding = false;
        decorations = "none";
        option_as_alt = "Both";
      };

      font = {
        size = 14;
        normal = {
          family = "Hack Nerd Font Mono";
        };
      };

      colors = {
        primary = {
          background = "0xfdf6e3";
          foreground = "0x657b83";
        };

        normal = {
          black = "0x002b36";
          red = "0xdc322f";
          green = "0x7d8d09";
          yellow = "0x6c71c4";
          blue = "0x073642";
          magenta = "0xd33682";
          cyan = "0x7d8d09";
          white = "0xeee8d5";
        };

        bright = {
          black = "0x002b36";
          red = "0xcb4b16";
          green = "0x586e75";
          yellow = "0x657b83";
          blue = "0x839496";
          magenta = "0x6c71c4";
          cyan = "0x93a1a1";
          white = "0xfdf6e3";
        };
      };

      # colors = {
      #   primary = {
      #     background = "0xfdf6e3";
      #     foreground = "0x586e75";
      #   };

      #   normal = {
      #     black = "0x073642";
      #     red = "0xdc322f";
      #     green = "0x859900";
      #     yellow = "0xb58900";
      #     blue = "0x268bd2";
      #     magenta = "0xd33682";
      #     cyan = "0x2aa198";
      #     white = "0xeee8d5";
      #   };

      #   bright = {
      #     black = "0x002b36";
      #     red = "0xcb4b16";
      #     green = "0x586e75";
      #     yellow = "0x657b83";
      #     blue = "0x839496";
      #     magenta = "0x6c71c4";
      #     cyan = "0x93a1a1";
      #     white = "0xfdf6e3";
      #   };
      # };
    };
  };
}
