{ ... }:
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      theme = "colorblind";
      # copy_command = "wl-copy";
      #default_layout = "compact";
      pane_frames = false;
      ui = {
        pane_frames = {
          hide_session_name = true;
        };
      };

      web_server = true;

      themes = {
        colorblind = {
          fg = "#95C4CC";
          bg = "#000000";
          black = "#000000";
          red = "#B00516";
          green = "#A3BE8C";
          yellow = "#EBCB8B";
          blue = "#81A1C1";
          magenta = "#B48EAD";
          cyan = "#9C88D0";
          white = "#898F8F";
          orange = "#C96438";
        };
      };
    };

    # Use extraConfig for keybinds with spaces (home-manager's structured settings don't handle them well)
    extraConfig = ''
      keybinds {
        unbind "Ctrl g"

        normal {
          bind "Ctrl l" {
            SwitchToMode "Locked"
          }
        }

        locked {
          bind "Ctrl l" {
            SwitchToMode "Normal"
          }
        }
      }
    '';
  };
}
