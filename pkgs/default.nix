# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs:
{
  # dashlane-cli = pkgs.callPackage ./dashlane { pkgs = pkgs; };
}
