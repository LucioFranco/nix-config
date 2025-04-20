{ config, ... }:
# { pkgs, ... }:
# (pkgs.lib.mapAttrs (_: darwin: darwin.system) config.flake.darwinConfigurations)
{
  "aarch64-darwin" = config.flake.darwinConfigurations;
}
