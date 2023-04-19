{ self, ... }:

localSystem:

with self.pkgs.${localSystem}; {
  default = mkShell {
    name = "nix-config";

    nativeBuildInputs = [
      # Nix
      nixfmt
    ];

    shellHook = ''
      ${self.checks.${localSystem}.pre-commit-check.shellHook}
    '';
  };
}
