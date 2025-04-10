{ self, ... }:

localSystem:

with self.pkgs.${localSystem}; {
  default = mkShell {
    name = "nix-config";

    nativeBuildInputs = [
      # Nix
      nixd
      nixfmt-classic
    ];

    shellHook = ''
      ${self.checks.${localSystem}.pre-commit-check.shellHook}
    '';
  };
}
