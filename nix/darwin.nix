{ pkgs, config, lib, ... }: {
  home-manager.users.luciofra = { config, ... }: {
    home.username = "luciofra";

    imports = [ ../home ];
  };

  home-manager.verbose = true;

  users.users.luciofra = {
    name = "luciofra";
    home = "/Users/luciofra";
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs;
      [ (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; }) ];
  };

  programs.zsh.enable = true;

  nix = { settings.experimental-features = [ "nix-command" "flakes" ]; };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

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
