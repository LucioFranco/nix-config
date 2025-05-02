{ pkgs, ... }:
{
  home.file.".cargo/config.toml" = {
    enable = true;
    text = pkgs.std.serde.toTOML {
      net = {
        git-fetch-with-cli = true;
      };
    };
  };
}
