{ pkgs, config, lib, ... }:
{
  environment.systemPackages =
    with pkgs; [
      neovim
      kitty
      alacritty
    ];


  users.users.luciofra = {
    name = "luciofra";
    home = "/Users/luciofra";
  };

  # fonts = {
  #   fontDir.enable = true;
  #   fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Hack" ]; }) ];
  # };

  programs.zsh.enable = true;

  imports = [
    ../home
  ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

    # Nix-darwin does not link installed applications to the user environment. This means apps will not show up
  # in spotlight, and when launched through the dock they come with a terminal window. This is a workaround.
  # Upstream issue: https://github.com/LnL7/nix-darwin/issues/214
  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in lib.mkForce ''
    # Set up applications.
    echo "setting up ~/Applications..." >&2

    rm -rf ~/Applications/Nix\ Apps
    mkdir -p ~/Applications/Nix\ Apps

    find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read src; do
          /bin/cp -cr "$src" ~/Applications/Nix\ Apps
        done
  ''; 
}
