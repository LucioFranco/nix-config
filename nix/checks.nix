{ self, pre-commit-hooks, ... }:

system:

with self.pkgs.${system};

{
  pre-commit-check = pre-commit-hooks.lib.${system}.run {
    src = lib.cleanSource ../.;
    hooks = {
      # actionlint.enable = true;
      # luacheck.enable = true;
      # nixpkgs-fmt.enable = true;
      nixfmt-classic.enable = true;
      shellcheck = {
        enable = false;
        types_or = lib.mkForce [ ];
      };
      # shfmt.enable = true;
      # statix.enable = true;
      # stylua.enable = true;
    };
  };
}
