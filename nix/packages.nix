{ withSystem, config, ... }:
{
  "aarch64-darwin".workbook = config.flake.darwinConfigurations.workbook.system;
  "x86_64-linux".wsl = config.flake.nixosConfigurations.wsl.config.system.build.toplevel;
  "x86_64-linux".window = withSystem "x86_64-linux" ({ pkgs, ... }: pkgs.window);
}
