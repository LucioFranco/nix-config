{ pkgs, ... }: {
  programs.tmux = {
    enable = true;

    extraConfig = ''
      set-option -g status-position top
    '';
  };
}
