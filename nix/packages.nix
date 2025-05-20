{ withSystem, config, ... }:
{
  "aarch64-darwin".workbook = config.flake.darwinConfigurations.workbook.system;
  "x86_64-linux" = withSystem "x86_64-linux" (
    { pkgs, ... }:
    {
      inherit (pkgs)
        # CI util
        nix-fast-build
        window
        compare
        n
        xdg-open-wsl
        jj-github-pr
        spr
        ;
      wsl = config.flake.nixosConfigurations.wsl.config.system.build.toplevel;
    }
  );
}
