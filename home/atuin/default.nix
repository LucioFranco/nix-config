{ ... }:
{
  age.secrets.key.file = ./key.age;

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    # TODO: figure out how to configure the file to read my own secert
    # settings = {
    #   key_path = config.age.secrets.key.path;
    # };
  };
}
