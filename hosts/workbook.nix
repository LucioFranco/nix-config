{
  pkgs,
  ...
}:
{
  home-manager.users.lucio =
    { ... }:
    {
      home.username = "lucio";
      home.stateVersion = "24.11";

      programs.wezterm.enable = true;

      imports = [ ../home ];
    };

  users.users.lucio = {
    name = "lucio";
    home = "/Users/lucio";
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;

    casks = [
      "iterm2"
      "firefox"
      "discord"
      "steam"
      "transmission"
      "the-unarchiver"
      "spotify"
      "rectangle"
      "slack"
      "private-internet-access"
      "caffeine"
      # "chrome"
    ];
  };

  environment.systemPackages = with pkgs; [
    qemu
    llvmPackages.libclang

    docker
    colima

    dashlane-cli

    # tmux-yank
    reattach-to-user-namespace

    unixtools.watch
  ];

  services.tailscale = {
    enable = true;
  };

  programs.zsh.enable = true;

  # Can't enable this with determintesys nix
  #services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  nix.enable = false;

  system.stateVersion = 24.11;
  system.primaryUser = "lucio";

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
  system.defaults.controlcenter.BatteryShowPercentage = true;

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

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
  };
}
