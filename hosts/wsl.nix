{
  pkgs,
  inputs,
  outputs,
  config,
  ...
}:
{

  wsl = {
    enable = true;
    defaultUser = "lucio";
  };

  environment.systemPackages = with pkgs; [
    dashlane-cli
    xdg-open-wsl
    mosh
  ];

  home-manager.users.lucio =
    { ... }:
    {
      home.username = "lucio";
      home.homeDirectory = "/home/lucio";

      home.stateVersion = "24.11";
      imports = [ ../home ];
    };

  virtualisation.docker = {
    enable = true;
    # setSocketVariable = true;
  };

  time = {
    timeZone = "America/New_York";
  };

  programs.nix-ld = {
    enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "lucio" ];

  users.users.lucio = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    # uid = 1000;
    password = "demo";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # age.secrets.tailscale.file = ./wsl/tailscale.age;
  # age.identityPaths = [ "/home/lucio/.ssh/id_ed25519" ];

  services.tailscale = {
    enable = true;
    # authKeyFile = config.age.secrets.tailscale.path;
    useRoutingFeatures = "both";
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };

    knownHosts."lucio".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMlNhZ2sZv0tgGXJ73vC9r7TvlSzFLPmnn5NMbEkoQlB";
  };

  networking.firewall = {
    # enable the firewall
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];

    # # let you SSH in over the public internet
    # allowedTCPPorts = [ 22 ];
  };
}
