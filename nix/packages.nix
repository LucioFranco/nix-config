{ withSystem, config, ... }:
{
  "aarch64-darwin" = withSystem "aarch64-darwin" (
    { pkgs, ... }:
    {
      inherit (pkgs)
        compare
        linear-cli
        ;
      workbook = config.flake.darwinConfigurations.workbook.system;
    }
  );
  "x86_64-linux" = withSystem "x86_64-linux" (
    { pkgs, ... }:
    {
      inherit (pkgs)
        compare
        n
        xdg-open-wsl
        ;
      wsl = config.flake.nixosConfigurations.wsl.config.system.build.toplevel;
    }
  );
}
