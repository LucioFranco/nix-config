{ ... }: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      theme = "colorblind";
      # copy_command = "wl-copy";
      default_layout = "compact";
      pane_frames = false;
      hide_session_name = true;

      keybinds = {
        unbind = [ "Ctrl h" "Ctrl p" ];
      };

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
  };
}
