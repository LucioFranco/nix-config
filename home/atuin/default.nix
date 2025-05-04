{ config, ... }: {
  age.secrets.key.file = ./key.age;

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      key_path = config.age.secrets.key.path;
    };
  };
}
