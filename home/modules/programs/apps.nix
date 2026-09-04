{ pkgs, ... }:

{
  # Define user programs and applications
  home.packages = with pkgs; [
    discord
    telegram-desktop
    spotify-spotx
    libreoffice
    google-chrome
    yt-dlp
    krita
    handbrake
  ];
}
