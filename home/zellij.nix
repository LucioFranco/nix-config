{ pkgs, ... }:
let
  zellij-autolock = pkgs.fetchurl {
    url = "https://github.com/fresh2dev/zellij-autolock/releases/download/0.2.2/zellij-autolock.wasm";
    sha256 = "69c95607bfd97e075d6762a44fdbc703a82a3c4909dbbbe43952f020487b8ea4";
  };
in
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      theme = "colorblind";
      # copy_command = "wl-copy";
      #default_layout = "compact";
      pane_frames = true;
      ui = {
        pane_frames = {
          hide_session_name = true;
          rounded_corners = true;
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

    # Use extraConfig for plugin configuration and keybinds
    extraConfig = ''
      plugins {
        autolock location="file:~/.config/zellij/plugins/zellij-autolock.wasm" {
          is_enabled true
          triggers "nvim|vim|v|nv|nvim-dev|fzf|zoxide|atuin"
          reaction_seconds "0.3"
          print_to_log false
        }
      }

      load_plugins {
        autolock
      }

      keybinds {
        unbind "Ctrl g"
        
        // Unbind default Alt+hjkl navigation so they pass through when locked
        unbind "Alt h"
        unbind "Alt j"  
        unbind "Alt k"
        unbind "Alt l"

        normal {
          bind "Ctrl p" {
            SwitchToMode "Pane";
          }
        }



        normal {
          bind "Enter" {
            WriteChars "\u{000D}";
            MessagePlugin "autolock" {};
          }
        }

        locked {
          bind "Alt z" {
            MessagePlugin "autolock" {payload "disable";};
            SwitchToMode "Normal";
          }
        }

        shared {
          bind "Alt Shift z" {
            MessagePlugin "autolock" {payload "enable";};
          }
        }

        shared_except "locked" {
          bind "Alt z" {
            MessagePlugin "autolock" {payload "disable";};
            SwitchToMode "Locked";
          }

          bind "Ctrl h" {
            MoveFocusOrTab "Left";
          }
          bind "Ctrl l" {
            MoveFocusOrTab "Right";
          }
          bind "Ctrl j" {
            MoveFocus "Down";
          }
          bind "Ctrl k" {
            MoveFocus "Up";
          }

          bind "Alt h" {
            Resize "Increase Left";
          }
          bind "Alt l" {
            Resize "Increase Right";
          }
          bind "Alt j" {
            Resize "Increase Down";
          }
          bind "Alt k" {
            Resize "Increase Up";
          }
        }
      }
    '';
  };

  # Install zellij-autolock plugin
  xdg.configFile."zellij/plugins/zellij-autolock.wasm".source = zellij-autolock;
}
