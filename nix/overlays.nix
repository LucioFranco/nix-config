# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
    # Pin nixfmt to the nextgen rfc style
    nixfmt = final.nixfmt-rfc-style;

    # Override the version of jujutsu esp since its coming from
    # the inputs since we source it directly from the git repo. There is
    # currently a bug with hm where the version generated from the flake input
    # is in the format of `unstable-{shortRev}` and this breaks the version check
    # done in hm to move the darwin config location based on the version. In order
    # to work around this for now I force pin the version to one that works with
    # the current hm code.
    #
    # Reference issue: https://github.com/nix-community/home-manager/pull/6994#issuecomment-2867905644
    jujutsu = (
      prev.jujutsu.overrideAttrs {
        version = "unstable-0.29.0";
      }
    );
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
