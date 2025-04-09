{ ... }: {
  home.file.".cargo/config.toml" = {
    enable = true;
    text = ''
      [net]
      git-fetch-with-cli = true
    '';
  };
}
