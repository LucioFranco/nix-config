{ pkgs, ... }:
{
  programs.k9s = {
    enable = true;
    package = pkgs.k9s;

    settings.k9s = {
      ui = {
        skin = "transparent-custom";
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
        transparent-custom = {
          k9s = {
            body = {
              bgColor = "default";
            };
            prompt = {
              bgColor = "default";
            };
            info = {
              fgColor = "#657b83";
              sectionColor = "default";
            };
            dialog = {
              bgColor = "default";
              fgColor = "#657b83";
              labelFgColor = "default";
              fieldFgColor = "default";
            };
            frame = {
              crumbs = {
                bgColor = "default";
              };
              title = {
                bgColor = "default";
                counterColor = "default";
              };
              menu = {
                fgColor = "#657b83";
              };
            };
            views = {
              charts = {
                fgColor = "#657b83";
                bgColor = "default";
              };
              table = {
                bgColor = "default";
                fgColor = "#657b83";
                header = {
                  fgColor = "#657b83";
                  bgColor = "default";
                };
              };
              xray = {
                bgColor = "default";
              };
              logs = {
                bgColor = "default";
                fgColor = "#657b83";
                indicator = {
                  bgColor = "default";
                  toggleOnColor = "default";
                  toggleOffColor = "default";
                };
              };
              yaml = {
                colonColor = "default";
                valueColor = "default";
              };
            };
          };
        };
      };
  };
}
