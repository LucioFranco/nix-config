{ ... }:
{
  programs.ghostty = {
    enable = true;
    # Ghostty on macos via nixpkgs is not available so use homebrew
    package = null;
    enableZshIntegration = true;

    settings = {
      theme = "Builtin Solarized Light";
      font-family = "Hack Nerd Font Mono";
      font-size = 14;
      # "macos-titlebar-style" = "hidden";
      "macos-icon" = "chalkboard";
      "window-padding-balance" = true;
      "background-blur-radius" = 20;
    };
  };
}
