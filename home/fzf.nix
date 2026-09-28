{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    defaultCommand = "rg --files --hidden --glob !.git";
    fileWidget.command = "rg --files --hidden --glob !.git";
    changeDirWidget.command = "fd --type d";
    historyWidget.command = "";
  };
}
