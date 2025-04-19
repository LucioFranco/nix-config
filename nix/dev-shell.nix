{ pkgs, config, ... }:
{
  default = pkgs.mkShell {
    name = "nix-config";

    nativeBuildInputs = with pkgs; [
      nixd
      nixfmt-rfc-style
      nix-output-monitor

      # Shell
      shellcheck
      shfmt
      config.treefmt.build.wrapper

      # GitHub Actions
      act
      actionlint
      python3
      python3Packages.pyflakes

      pre-commit
    ];

    shellHook = ''
      ${config.pre-commit.installationScript}
    '';
  };
}
