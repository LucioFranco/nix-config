{ pkgs }:

let
  version = "1.9.1";

  binaries = {
    "aarch64-darwin" = {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-aarch64-apple-darwin.tar.xz";
      sha256 = "sha256-ZfT+9DdLT9e1GtQSlu2J3fHFQYnUEzijSHNYpElfaWs=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-x86_64-apple-darwin.tar.xz";
      sha256 = "sha256-48oKJytD8iUzKugMaTUM+aJKB9Hg1C+3jF6kaW6wQF0=";
    };
    "x86_64-linux" = {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-x86_64-unknown-linux-gnu.tar.xz";
      sha256 = "sha256-+LEDaEK9WIDPBfR2krTwnAq7Oq01LxjL9O6V3z7C87s=";
    };
    "aarch64-linux" = {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-aarch64-unknown-linux-gnu.tar.xz";
      sha256 = "sha256-FZ1zfQqIoX9IXq28Ti5AN+omqwwJGYsAtVbld3pSgN8=";
    };
  };

  system = pkgs.stdenv.hostPlatform.system;

  bin = binaries.${system} or (throw "linear-cli: unsupported system ${system}");

in
pkgs.stdenv.mkDerivation {
  pname = "linear-cli";
  inherit version;

  src = pkgs.fetchurl { inherit (bin) url sha256; };

  nativeBuildInputs = [ pkgs.xz ];

  unpackPhase = ''
    tar xf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp linear-*/linear $out/bin/linear
    chmod +x $out/bin/linear
  '';
}
