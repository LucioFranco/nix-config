{ pkgs, ... }: {
  programs.git = {
    enable = true;
    includes = [
      # github config
      {
        condition = "gitdir/i:~/code/";
        contents = {
          user = {
            name = "Lucio Franco";
            email = "luciofranco14@gmail.com";
          };
          push = { autoSetupRemote = true; };
        };
      }

      # Amazon config
      {
        condition = "gitdir/i:~/workplace/";
        contents = {
          user = {
            name = "Lucio Franco";
            email = "foo";
          };
        };
      }
    ];

    ignores = [ ".DS_Store" "*.dSYM" ".envrc" ".direnv" "CLAUDE.md" ];
  };

  home.shellAliases = rec {
    ga = "git add";
    gca = "git commit -a";
    gc = "git commit";
    gs = "git status";
    gd = "git diff";
    gdc = "git diff --cached";
    gch = "git checkout";
  };
}
