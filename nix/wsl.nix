{ pkgs, config, lib, ... }: {
  home.username = "lucio";
  home.homeDirectory = "/home/lucio";

  imports = [ ../home ];
}
