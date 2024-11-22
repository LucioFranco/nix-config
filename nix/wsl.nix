{ pkgs, config, lib, inputs, ... }: {
  home.username = "lucio";
  home.homeDirectory = "/home/lucio";
  home.stateVersion = "24.11";

  home.packages = [
    inputs.xdg-open-wsl.packages."x86_64-linux".xdg-open
  ];

  imports = [ ../home ];
}
