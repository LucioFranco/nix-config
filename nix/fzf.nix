{ pkgs, ... }: {
  programs.fzf = {
    enable = true;
    defaultCommand = "rg --files --hidden --glob !.git";
    fileWidgetCommand = "rg --files --hidden --glob !.git";
    changeDirWidgetCommand = "fd --type d";
  };
}
