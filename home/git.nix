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
          push = {
            autoSetupRemote = true;
          };
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
  };

  home.shellAliases = rec {
    ga = "git add";
    gca = "git commit --add";
    gc = "git commit";
    gs = "git status";
    gd = "git diff";
    gdc = "git diff --cached";
    gch = "git checkout";
  };
}
