{ ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Lucio Franco";
        email = "luciofranco14@gmail.com";
      };

      git = {
        push-bookmark-prefix = "lucio/push-";
        private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
      };

      merge-tools.diffconflicts = {
        program = "nvim";
        merge-args = [
          "-c"
          "let g:jj_diffconflicts_marker_length=$marker_length"
          "-c"
          "JJDiffConflicts!"
          "$output"
          "$base"
          "$left"
          "$right"
        ];
        merge-tool-edits-conflict-markers = true;
      };
    };
  };
}
