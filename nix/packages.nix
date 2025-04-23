{ withSystem, config, ... }:
{
  "aarch64-darwin".workbook = config.flake.darwinConfigurations.workbook.system;
  "x86_64-linux" = withSystem "x86_64-linux" (
    { pkgs, ... }:
    {
      inherit (pkgs)
        window
        compare
        n
        xdg-open-wsl
        ;
      wsl = config.flake.nixosConfigurations.wsl.config.system.build.toplevel;
    }
  );
}
