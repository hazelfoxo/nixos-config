{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "spotify-adblock";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "abba23";
    repo = "spotify-adblock";
    rev = "v1.1.0";
    hash = lib.fakeHash;
  };

  cargoHash = lib.fakeHash;
}
