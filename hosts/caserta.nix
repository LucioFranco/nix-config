{
  pkgs,
  config,
  ...
}:
{
  home-manager.users.lucio =
    { config, ... }:
    {
      home.username = "lucio";
      home.stateVersion = "24.11";

      home.sessionPath = [ "${config.home.homeDirectory}/code/moose/result/bin" ];

      imports = [ ../home ];

      home.packages = with pkgs; [
        linctl
      ];

      programs.ssh = {
        enable = true;
        matchBlocks."github.com" = {
          identityFile = "~/.ssh/id_ed25519_github";
          identitiesOnly = true;
        };
      };

      xdg.configFile."ghostty/config" = {
        text = ''
          # Ghostty configuration
          theme = Builtin Solarized Light
          font-family = "Hack Nerd Font Mono"
          #font-size = 12

          # Add your custom settings here
          #window-padding-x = 10
          #window-padding-y = 10
          # Remove window decorations (borders, title bar)
          window-decoration = false

          # Optional: also remove internal padding
          window-padding-x = 0
          window-padding-y = 0
        '';
      };
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
      # "private-internet-access"
      "caffeine"
      # "chrome"
      "ghostty"
      "figma"
      "claude"
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

  nix.package = pkgs.nix;
  nix.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ config.users.users.lucio.name ];

  networking.hostName = "caserta";

  system.stateVersion = 6;
  system.primaryUser = config.users.users.lucio.name;

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
