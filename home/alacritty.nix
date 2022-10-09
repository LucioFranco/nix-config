{ pkgs, ... }: {
  programs.alacritty = {
      enable = true;

      settings = {
        window.decorations = "none";
      };
    };
}
