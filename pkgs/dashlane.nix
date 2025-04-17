{ pkgs }:

let
  version = "6.2447.2";

  binaries = {
    "x86_64-linux" = {
      url =
        "https://github.com/Dashlane/dashlane-cli/releases/download/v${version}/dcli-linux-x64";
      sha256 = "sha256-kFEMjf5ylHb/TgzUsQ0DZ0cfflgbv6ZkdaDwlznRXfE=";
    };
    "x86_64-darwin" = {
      url =
        "https://github.com/Dashlane/dashlane-cli/releases/download/v${version}/dcli-macos-x64";
      sha256 = "";
    };
    "aarch64-darwin" = {
      url =
        "https://github.com/Dashlane/dashlane-cli/releases/download/v${version}/dcli-macos-arm64";
      sha256 = "sha256-fmJAV9H1ZTnP+2p5CgB1/6oNYK043AhMsGsMTTbFe6M=";
    };
  };

  system = pkgs.stdenv.hostPlatform.system;

  bin =
    binaries.${system} or (throw "dashlane-cli: unsupported system ${system}");

in pkgs.stdenv.mkDerivation {
  pname = "dashlane-cli";
  inherit version;

  src = pkgs.fetchurl { inherit (bin) url sha256; };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/dcli
    chmod +x $out/bin/dcli
  '';
}

