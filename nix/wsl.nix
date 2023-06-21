{ pkgs, config, lib, ... }: {
  home.username = "lucio";
  home.homeDirectory = "/home/lucio";
  home.stateVersion = "23.11";

  imports = [ ../home ];
}
