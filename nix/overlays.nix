# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final;

  modifications = final: prev: {
    # Empty for now
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    # unstable = import inputs.nixpkgs-unstable {
    #   system = final.system;
    #   config.allowUnfree = true;
    # };
  };
}
