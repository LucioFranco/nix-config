{ pkgs, inputs, outputs, config, ... }: {

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  # environment.systemPackages = with pkgs; [ dashlane-cli ];

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };
  services.displayManager.defaultSession = "xfce";

  home-manager.users.lucio = { ... }: {
    home.username = "lucio";
    home.homeDirectory = "/home/lucio";

    home.stateVersion = "24.11";
    imports = [ ../home ];

    # wayland.windowManager.sway = {
    #   enable = true;

    #   config = {
    #     bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];

    #     # keybindings =
    #     #   let
    #     #     modifier = config.wayland.windowManager.sway.config.modifier;
    #     #   in
    #     #   lib.mkOptionDefault { 
    #     #     "${modifier}+
    #     #   };

    #     input = { "*" = { xkb_options = "ctrl:nocaps"; }; };

    #     terminal = "${pkgs.alacritty}/bin/alacritty";
    #   };

    #   systemd.enable = true;
    # };

    programs.firefox = {
      enable = true;

      profiles.default = { isDefault = true; };
    };
  };

  virtualisation.docker = {
    enable = true;
    # setSocketVariable = true;
  };

  time = { timeZone = "America/New_York"; };

  programs.nix-ld = { enable = true; };

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
