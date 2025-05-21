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
        "$package"
        "$direnv"
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
    };
  };

  xdg.configFile."starship-jj/starship-jj.toml" = {
    enable = true;
    text = pkgs.std.serde.toTOML {
      module_separator = " ";
      # timeout = 1000;  # commented out in original

      bookmarks = {
        exclude = [ ];
        # search_depth = 0;
      };

      module = [
        # [[module]] Bookmarks
        {
          type = "Bookmarks";
          separator = " ";
          color = "Magenta";
          # bg_color    = "Yellow";
          behind_symbol = "⇡";
          # max_bookmarks = 1;
          # max_length    = 10;
        }

        # [[module]] Commit
        {
          type = "Commit";
          max_length = 24;
          color = "Black";
          # bg_color = "Yellow";
        }

        # [[module]] State (with subtables)
        {
          type = "State";
          separator = " ";

          conflict = {
            text = "(CONFLICT)";
            color = "Red";
            # bg_color = "Yellow";
          };

          divergent = {
            text = "(DIVERGENT)";
            color = "Cyan";
            # bg_color = "Yellow";
          };

          hidden = {
            disabled = false;
            text = "(HIDDEN)";
            color = "Yellow";
            # bg_color = "Yellow";
          };

          immutable = {
            disabled = false;
            text = "(IMMUTABLE)";
            color = "Yellow";
          };
        }

        # [[module]] Metrics (with subtables)
        {
          type = "Metrics";
          color = "Magenta";
          # bg_color = "Yellow";
          template = "[{changed} {added}{removed}]";

          changed_files = {
            # suffix = "";
            # prefix = "";
            color = "Cyan";
            # bg_color = "Yellow";
          };

          added_lines = {
            prefix = "+";
            # suffix = "";
            color = "Green";
            # bg_color = "Yellow";
          };

          removed_lines = {
            yprefix = "-";
            # suffix = "";
            color = "Red";
            # bg_color = "Yellow";
          };
        }
      ];
    };
  };

  home.packages = [ pkgs.starship-jj ];
}
