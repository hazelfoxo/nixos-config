{ pkgs, ... }:

{
    # Define user programs and applications
    home.packages = with pkgs; [
        discord
        telegram-desktop
        localsend
        pkgs.spotify-spotx
        libreoffice
        google-chrome
        yt-dlp
        krita
    ];
}
