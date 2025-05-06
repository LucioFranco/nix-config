# Settings taken from https://zerowidth.com/2025/jj-tips-and-tricks/
{ ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Lucio Franco";
        email = "luciofranco14@gmail.com";
      };

      ui = {
        default-command = "log-recent";
      };

      aliases = {
        log-recent = [
          "log"
          "-r"
          "ignore_spr(recent())"
        ];
        log-work = [
          "log"
          "-r"
          "mutable_branches()"
        ];
        log-trunk = [
          "log"
          "-r"
          "trunk()"
        ];
        c = [ "commit" ];
        ci = [
          "commit"
          "--interactive"
        ];
        e = [ "edit" ];
        i = [
          "git"
          "init"
          "--colocate"
        ];
        nb = [
          "bookmark"
          "create"
          "-r @-"
        ]; # "new bookmark"
        pull = [
          "git"
          "fetch"
        ];
        push = [
          "git"
          "push"
        ];
        # jj bookmark move --from 'heads(::@- & bookmarks())' --to @-
        tug = [
          "bookmark"
          "move"
          "--from"
          "ancestor_bookmark()"
          "--to"
          "@-"
        ];
        r = [ "rebase" ];
        s = [ "squash" ];
        d = [ "desc" ];
        si = [
          "squash"
          "--interactive"
        ];
      };

      revset-aliases = {
        # set all remote bookmarks (commits pushed to remote branches) to be immutable
        # "immutable_heads()" = "builtin_immutable_heads() | remote_bookmarks()";
        "recent()" = "committer_date(after:\"3 months ago\")";
        "ancestor_bookmark()" = "heads(::@- & bookmarks())";
        "ignore_spr(x)" = "x ~ subject(\"[spr]\")";
        "mutable_branches()" = "all:trunk().. ~ (trunk()..(remote_bookmarks()|immutable_heads()))::";
      };

      template-aliases = {
        "format_short_change_id(id)" = "id.shortest()";
      };

      git = {
        push-bookmark-prefix = "lucio/push-";
        private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
        push-new-bookmarks = true;
      };

      merge-tools.hunk = {
        program = "nvim";
        merge-args = ["-c" "DiffEditor" "$left" "$right" "$output"];
        merge-tool-edits-conflict-markers = true;
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
