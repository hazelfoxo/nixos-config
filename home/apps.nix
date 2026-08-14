{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    telegram-desktop
    spotify
    localsend
    pkgs."spotify-adblock"
    libreoffice
  ];
}
