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
    nerd-fonts
  ];

  home-manager.users.lucio = { ... }: {
    home.username = "lucio";
    home.homeDirectory = "/home/lucio";

    home.stateVersion = "23.11";
    imports = [ ../home ];

    wayland.windowManager.sway = {
      enable = true;

      config = {
        bars = [{
          command = "${pkgs.waybar}/bin/waybar";
        }];

        # keybindings =
        #   let
        #     modifier = config.wayland.windowManager.sway.config.modifier;
        #   in
        #   lib.mkOptionDefault { 
        #     "${modifier}+
        #   };

        input = {
          "*" = {
            xkb_options = "ctrl:nocaps";
          };
        };

        terminal = "${pkgs.alacritty}/bin/alacritty";
      };

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
    waybar
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "lucio" ];

  users.users.lucio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
    password = "demo";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
