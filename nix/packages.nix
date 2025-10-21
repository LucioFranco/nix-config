{ withSystem, config, ... }:
{
  "aarch64-darwin" = withSystem "aarch64-darwin" (
    { pkgs, ... }:
    {
      inherit (pkgs)
        window
        compare
        linctl
        ;
      workbook = config.flake.darwinConfigurations.workbook.system;
    }
  );
  "x86_64-linux" = withSystem "x86_64-linux" (
    { pkgs, ... }:
    {
      inherit (pkgs)
        window
        compare
        n
        xdg-open-wsl
        linctl
        ;
      wsl = config.flake.nixosConfigurations.wsl.config.system.build.toplevel;
    }
  );
}
