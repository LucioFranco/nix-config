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
}
