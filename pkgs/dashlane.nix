{ pkgs, ... }:
let
  dashlaneSrc = pkgs.fetchFromGithub {
    owner = "Dashlane";
    repo = "dashlane-cli";
    rev = "423517344b4f328a297d7a87147f3be1c49e77a3";
    sha = "";
  };
in (import ./dashlane-yarn.nix {
  inherit (pkgs)
    lib stdenv nodejs git cacert fetchurl writeShellScript writeShellScriptBin;
}) {
  src = dashlaneSrc;
  buildInputs = with pkgs; [ nodejs yarn python3 ];
  buildPhase = ''
    yarn run build
  '';
  buildVars = ''
    # Make Yarn produce friendlier logging for automated builds.
    export CI=1
    # Tell node-pre-gyp to never fetch binaries / always build from source.
    export npm_config_build_from_source=true
    # Disable Nixify plugin to save on some unnecessary processing.
    export yarn_enable_nixify=false
    export PYTHON=${pkgs.python3.out}/bin/python
  '';
}

