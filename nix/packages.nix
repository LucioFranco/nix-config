{ config, ... }:
{ pkgs, ... }:
(pkgs.lib.mapAttrs (_: darwin: darwin.system) config.flake.darwinConfigurations)
