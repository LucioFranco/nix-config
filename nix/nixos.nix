{ pkgs, inputs, outputs, config, ... }: {

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  environment.systemPackages = with pkgs; [ dashlane-cli ];

  disabledModules = [ "virtualisation/vmware-guest.nix" ];

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };

    # autoRepeatDelay = 10;
    # autoRepeatInterval = 1;
  };
  services.displayManager.defaultSession = "xfce";

  # Share our host filesystem
  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=1000"
      "gid=1000"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };

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
