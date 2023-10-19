{ inputs, pkgs, config, lib, ... }: {
  home-manager.users.lucio = { config, ... }: {
    home.username = "lucio";
    home.stateVersion = "23.11";


    imports = [ ../home ];
  };

  home-manager.verbose = true;

  users.users.lucio = {
    name = "lucio";
    home = "/Users/lucio";
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;

    casks = [
      "firefox"
      "discord"
      "steam"
      "transmission"
      "the-unarchiver"
      "spotify"
      "rectangle"
      "slack"
    ];
  };

  environment.systemPackages = with pkgs; [
    darwin.apple_sdk.frameworks.Security
    qemu
    llvmPackages.libclang

    darwin.iproute2mac
  ];

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs;
      [ (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; }) ];
  };

  programs.zsh.enable = true;

  # nix = { settings.experimental-features = [ "nix-command" "flakes" ]; };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.NSGlobalDomain._HIHideMenuBar = false;

  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "bottom";
  system.defaults.dock.showhidden = true;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  launchd.daemons.limits = {
    script = ''
      /bin/launchctl limit maxfiles 524288 524288
      /bin/launchctl limit maxproc 8192 8192
    '';
    serviceConfig.RunAtLoad = true;
    serviceConfig.KeepAlive = false;
  };

  system.activationScripts.applications.text = pkgs.lib.mkForce (
    ''
      echo "setting up ~/Applications..." >&2
      rm -rf ~/Applications/Nix\ Apps
      mkdir -p ~/Applications/Nix\ Apps
      for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
        src="$(/usr/bin/stat -f%Y "$app")"
        cp -r "$src" ~/Applications/Nix\ Apps
      done
    ''
  );
}
