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

  nix.settings.trusted-users = [ "lucio" ];

  users.users.lucio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    # uid = 1000;
    password = "demo";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
