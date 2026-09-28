{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    # Ghostty on macos via nixpkgs is not available so use homebrew
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty;
    enableZshIntegration = true;

    settings = {
      theme = "iTerm2 Solarized Light";
      font-family = "Hack Nerd Font Mono";
      font-size = 14;
      "macos-icon" = "chalkboard";
      "window-padding-balance" = true;
      "background-blur-radius" = 20;
    };
  };
}
