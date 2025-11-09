{ ... }:
{
  programs.zed-editor = {
    enable = true;

    userSettings = {
      theme = "solarized-light";
      vim_mode = true;
    };
  };
}
