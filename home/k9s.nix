{ pkgs, ... }:
{
  programs.k9s = {
    enable = true;
    package = pkgs.k9s;

    settings.k9s = {
      ui = {
        skin = "transparent";
        headless = false;
        crumbsless = false;
        splashless = true;
        logoless = true;
      };
      noExitOnCtrlC = true;
      skipLatestRevCheck = true;
    };

    skins =
      let
        src = pkgs.fetchFromGitHub {
          owner = "derailed";
          repo = "k9s";
          tag = "v${pkgs.k9s.version}";
          sha256 = "sha256-cL7OD9OtkVx325KcANU8FudcOk6HMct6ve2p0qSkEoc=";
        };
      in
      {
        solarized-light = "${src}/skins/solarized-light.yaml";
        transparent = "${src}/skins/transparent.yaml";
      };
  };
}
