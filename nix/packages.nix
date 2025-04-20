{ config, ... }:
{
  "aarch64-darwin".workbook = config.flake.darwinConfigurations.workbook.system;
}
