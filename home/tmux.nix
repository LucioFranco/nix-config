{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    clock24 = false;
    terminal = "tmux-256color";
    newSession = true;
    sensibleOnTop = true;
    historyLimit = 30000;
    escapeTime = 0;

    keyMode = "vi";
    prefix = "C-b";
    secureSocket = false;

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      better-mouse-mode
      yank
      {
        # https://github.com/seebi/tmux-colors-solarized
        plugin = tmux-colors-solarized;
        extraConfig = ''
          set -g @colors-solarized 'light'
        '';
      }
    ];

    extraConfig = ''
      set -gu default-command
      set -g default-shell ${pkgs.zsh}/bin/zsh

      set-option -g status-position top

      set -g update-environment -r
      set-option -g mouse on

      set -ag terminal-overrides ",alacritty*:Tc,foot*:Tc,xterm-kitty*:Tc,xterm-256color:Tc"

      set -as terminal-features ",alacritty*:RGB,foot*:RGB,xterm-kitty*:RGB"
      set -as terminal-features ",alacritty*:hyperlinks,foot*:hyperlinks,xterm-kitty*:hyperlinks"
      set -as terminal-features ",alacritty*:usstyle,foot*:usstyle,xterm-kitty*:usstyle"

      bind R source-file ${config.xdg.configHome}/tmux/tmux.conf \; display-message "Config reloaded..."

      bind L clear-history
      bind C-a last-window

      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      set-option -g status-interval 1
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'

      # Start windows and panes at 1, not 0
      set -g base-index 1
      setw -g pane-base-index 1
      set-option -g renumber-windows on

      setw -g monitor-activity on
      set -g visual-activity off

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      # This config is related to https://github.com/mrjones2014/smart-splits.nvim
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n C-h if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n C-j if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n C-k if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n C-l if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

      bind-key -n M-h if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 3'
      bind-key -n M-j if-shell "$is_vim" 'send-keys M-j' 'resize-pane -D 3'
      bind-key -n M-k if-shell "$is_vim" 'send-keys M-k' 'resize-pane -U 3'
      bind-key -n M-l if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 3'

      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
    '';
  };

  home.packages = [
    # Open jj watchers
    (pkgs.writeShellApplication {
      name = "watch-jj";
      runtimeInputs = with pkgs; [
        tmux
        jujutsu
      ];
      text = ''
        #!/usr/bin/env zsh

        # Width of the right column as a percentage of the full window
        RIGHT_PCT=35

        # Get current pane (this will be left)
        LEFT_PANE=$(tmux display-message -p '#{pane_id}')

        # Step 1: Split horizontally, right pane gets $RIGHT_PCT of width
        tmux split-window -h -p $RIGHT_PCT -t "$LEFT_PANE" "zsh -i -c 'watch-log'"

        # Get the new right pane ID (top right)
        TOP_RIGHT_PANE=$(tmux display-message -p -t "$LEFT_PANE".+1 '#{pane_id}')

        # Step 2: Split right pane vertically in half (default is 50/50)
        tmux split-window -v -t "$TOP_RIGHT_PANE" "zsh -i -c 'watch-st'"

        tmux select-pane -t "$LEFT_PANE"
      '';
    })
  ];
}
