{ pkgs, config, ... }: {
  wsl = {
    enable = true;
    defaultUser = "lucio";
  };

  home-manager.users.lucio = { ... }: {
    home.username = "lucio";
    home.homeDirectory = "/home/lucio";

    home.stateVersion = "24.11";
    imports = [ ../home ];
  };

  virtualisation.docker = {
    enable = true;
    # setSocketVariable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "lucio" ];

  users.users.lucio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    # uid = 1000;
    password = "demo";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
