{ pkgs, lib, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "\${custom.jj}"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$package"
        "$haskell"
        "$python"
        "$rust"
        "$nix_shell"
        "$line_break"
        "$jobs"
        "$character"
      ];

      custom.jj = {
        command = "starship-jj --ignore-working-copy starship prompt";
        format = "[$symbol](blue bold) $output ";
        symbol = "󱗆 ";
        when = "jj root --ignore-working-copy";
      };

      # custom.jj = {
      #   command = ''
      #     jj log -r@ -n1 --ignore-working-copy --no-graph --color always -T '
      #       separate(" ",
      #         bookmarks.map(|x| truncate_end(10, x.name(), "…")).join(" "),
      #         tags.map(|x| truncate_end(10, x.name(), "…")).join(" "),
      #         surround("\"", "\"", truncate_end(24, description.first_line(), "…")),
      #         if(conflict, "conflict"),
      #         if(divergent, "divergent"),
      #         if(hidden, "hidden"),
      #       )
      #     '
      #   '';
      #   when = "jj root";
      #   symbol = "jj";
      # };

      # # `jjstate` module
      # custom.jjstate = {
      #   when = "jj root";
      #   command = ''
      #     jj log -r@ -n1 --no-graph -T "" --stat \
      #     | tail -n1 \
      #     | sd "(\d+) files? changed, (\d+) insertions?\(\+\), (\d+) deletions?\(-\)" ' ${1}m ${2}+ ${3}-' \
      #     | sd " 0." ""
      #   '';
      # };
    };
  };

  home.packages = [ pkgs.starship-jj ];
}
