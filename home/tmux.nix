{ pkgs, ... }: {
  programs.tmux = {
    enable = true;

    clock24 = false;
    #terminal = "tmux-256color";
    newSession = true;
    sensibleOnTop = false;
    historyLimit = 30000;

    keyMode = "vi";
    prefix = "C-b";

    plugins = with pkgs.tmuxPlugins; [ vim-tmux-navigator ];

    extraConfig = ''
      set-option -g status-position top

      bind R source-file ~/.tmux.conf \; display-message "Config reloaded..."

      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      set -g allow-rename on
      set-window-option -g automatic-rename
      set-option -g automatic-rename-format '#{b:pane_current_path}'

      setw -g monitor-activity on
      set -g visual-activity off
    '';
  };
}
