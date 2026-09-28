{ lib, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$directory"
        "$direnv"
        "$nix_shell"
        "$line_break"
        "$jobs"
        "$character"
      ];

      nix_shell = {
        format = "via ($name)";
      };
    };
  };
}
