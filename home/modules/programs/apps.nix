{ pkgs, ... }:

{
  # Define user programs and applications
  home.packages = with pkgs; [
    discord
    telegram-desktop
    spotify-spotx
    libreoffice
    yt-dlp
    krita
    handbrake
  ];
}
