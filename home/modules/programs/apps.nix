{ pkgs, ... }:

# Configure additional programs and packages

{
  home.packages = with pkgs; [
    discord
    telegram-desktop
    libreoffice
    yt-dlp
  ];
}
