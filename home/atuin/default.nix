{ ... }:
{
  age.secrets.key.file = ./key.age;

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = false;
      # key_path = config.age.secrets.key.path;
    };
  };
}
