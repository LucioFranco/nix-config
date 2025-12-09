{ ... }:
{
  programs.zed-editor = {
    enable = true;

    # Install solarized theme extension
    extensions = [ "solarized" ];

    userSettings = {
      theme = "Solarized Light";
      vim_mode = true;

      # Protanomaly-friendly high contrast theme
      theme_overrides = {
        "Solarized Light" = {
          # High contrast base text (dark charcoal, not pure black)
          "editor.foreground" = "#2e2e2eff";
          "text" = "#2e2e2eff";

          # Syntax highlighting - protanomaly-friendly colors
          "syntax" = {
            # Comments - medium gray (brightness-based contrast)
            "comment" = {
              "color" = "#767470ff";
              "font_style" = "italic";
            };
            "comment.doc" = {
              "color" = "#767470ff";
              "font_style" = "italic";
            };

            # Keywords - dark charcoal
            "keyword" = {
              "color" = "#2e2e2eff";
            };

            # Modifiers (pub, static, etc.) - dark charcoal
            "modifier" = {
              "color" = "#2e2e2eff";
            };

            # Attributes - dark charcoal
            "attribute" = {
              "color" = "#2e2e2eff";
            };

            # Strings - blue (safe for protanomaly, reusing diff blue)
            "string" = {
              "color" = "#0969daff";
            };
            "string.regex" = {
              "color" = "#0969daff";
            };
            "string.escape" = {
              "color" = "#0969daff";
            };

            # Numbers/Constants - orange/yellow (safe for protanomaly)
            "number" = {
              "color" = "#fb8500ff";
            };
            "constant" = {
              "color" = "#fb8500ff";
            };

            # Functions - purple/indigo (blue-based, safe)
            "function" = {
              "color" = "#471accff";
            };

            # Types - dark charcoal (high contrast)
            "type" = {
              "color" = "#2e2e2eff";
            };

            # Variables - dark charcoal
            "variable" = {
              "color" = "#2e2e2eff";
            };

            # Properties - dark charcoal
            "property" = {
              "color" = "#2e2e2eff";
            };
          };

          # Project panel (tree explorer) - darker text for better contrast
          "text.muted" = "#2e2e2eff"; # Tree explorer items

          # Git diff colors (for file changes)
          # Blue for added lines (GitHub colorblind style)
          "version_control.added" = "#0969daff";
          # Red for deleted lines (GitHub colorblind style)
          "version_control.deleted" = "#d1242fff";
          # Orange for modified lines
          "version_control.modified" = "#fb8500ff";
          # Subtle backgrounds for conflict markers
          "version_control.conflict_marker.ours" = "#0969da1a";
          "version_control.conflict_marker.theirs" = "#d1242f1a";

          # AI suggestion colors (for inline assistant/edit predictions)
          # Blue tint for AI predictions (consistent with "added" concept)
          "predictive" = "#0969daff";
          "predictive.background" = "#0969da1a";
          "predictive.border" = "#0969da80";
        };
      };

      # Enable git diff indicators in scrollbar
      scrollbar = {
        show = "auto";
        git_diff = true;
      };
    };
  };
}
