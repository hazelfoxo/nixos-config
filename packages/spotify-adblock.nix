{ lib, fetchFromGitHub, rustPlatform }:

let
  version = "1.1.1";
in
rustPlatform.buildRustPackage {
  pname = "spotify-adblock";
  inherit version;

  src = fetchFromGitHub {
    owner = "abba23";
    repo = "spotify-adblock";
    rev = "v${version}";
    hash = "sha256-R1xM/a+EzFd3I94EVCphbW+M114x6CtIeCOi9Fd9tpc=";
  };

  cargoHash = "sha256-gxGetdqaoJa/ZF1VnW6UXJyJfLBGZxZnyKpT/Qk/8Og=";

  postInstall = ''
    mkdir -p $out/share/applications

    cat > $out/share/applications/spotify-adblock.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Name=Spotify (adblock)
    GenericName=Music Player
    Icon=spotify-client
    TryExec=spotify
    Exec=env LD_PRELOAD=$out/lib/spotify-adblock.so spotify %U
    Terminal=false
    MimeType=x-scheme-handler/spotify;
    Categories=Audio;Music;Player;AudioVideo;
    StartupWMClass=spotify
    EOF
  '';
}
