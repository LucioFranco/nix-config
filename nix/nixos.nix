{ pkgs, ... }: {
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
  ];

  home-manager.users.lucio = { ... }: {
    home.username = "lucio";
    home.homeDirectory = "/home/lucio";

    home.stateVersion = "23.11";
    imports = [ ../home ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "lucio" ];

  boot.growPartition = true;
  boot.loader.grub.device = "/dev/sda";

  swapDevices = [{
    device = "/var/swap";
    size = 2048;
  }];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
    };
  };

  virtualisation.virtualbox.guest.enable = true;

  boot.loader.grub.fsIdentifier = "provided";

  users.user.lucio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1001;
    password = "demo";
  };

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
      gdm.enable = true;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ dmenu i3status i3lock ];
    };
  };
}
