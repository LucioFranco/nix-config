{ pkgs, config, ... }: {
  imports = [
    ../hardware/thinkpad-hardware.nix
  ];


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad";

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    nerdfonts
  ];

  home-manager.users.lucio = { ... }: {
    home.username = "lucio";
    home.homeDirectory = "/home/lucio";

    home.stateVersion = "23.11";
    imports = [ ../home ];

    wayland.windowManager.sway = {
      enable = true;

      extraConfig = ''
        input "*" {
          xkb_options ctrl:nocaps
        }
      '';

      systemd.enable = true;
    };

    programs.firefox = {
      enable = true;

      profiles.default = {
        isDefault = true;
        extensions = with config.nur.repos.rycee.firefox-addons; [
          ublock-origin
        ];
      };
    };
  };

  security.polkit.enable = true;

  networking.networkmanager = {
    enable = true;

    wifi = {
      scanRandMacAddress = false;
    };
  };

  hardware.opengl = {
    enable = true;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  environment.systemPackages = with pkgs; [
    sway
    swaylock
    swayidle
    wofi
    glib
    wayland
    kanshi

    wl-clipboard
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "lucio" ];

  # boot.growPartition = true;
  # boot.loader.grub.device = "/dev/sda";

  # swapDevices = [{
  #   device = "/var/swap";
  #   size = 2048;
  # }];

  # fileSystems = {
  #   "/" = {
  #     device = "/dev/disk/by-label/nixos";
  #     autoResize = true;
  #     fsType = "ext4";
  #   };
  # };

  # virtualisation.virtualbox.guest.enable = true;

  # boot.loader.grub.fsIdentifier = "provided";

  users.users.lucio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
    password = "demo";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # services.xserver = {
  #   enable = true;
  #   desktopManager = {
  #     xterm.enable = false;
  #   };

  #   displayManager = {
  #     defaultSession = "none+i3";
  #     gdm.enable = true;
  #   };

  #   windowManager.i3 = {
  #     enable = true;
  #     extraPackages = with pkgs; [ dmenu i3status i3lock ];
  #   };
  # };
}
