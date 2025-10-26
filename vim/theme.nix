{ pkgs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "solarized-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "maxmx03";
        repo = "solarized.nvim";
        tag = "v3.6.0";
        sha256 = "sha256-fNytlDlYHqX1W1pqt8xLoud+AtMQDlmtUkbwZArj4bs=";
      };
    })
  ];

  extraConfigLua = ''
    -- require('solarized').setup({
    --   options = {
    --   },
    -- });
  '';
}
