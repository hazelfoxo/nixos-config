{ pkgs, ... }:

# Configure additional programs and packages

{
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
