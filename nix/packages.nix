{ config, ... }:
{
  "aarch64-darwin".workbook = config.flake.darwinConfigurations.workbook.system;
  "x86_64-linux".wsl = config.flake.nixosConfigurations.wsl.config.system.build.toplevel;
}
