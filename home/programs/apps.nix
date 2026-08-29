{ pkgs, ... }:

{
    # Define user programs and applications
    home.packages = with pkgs; [
        discord
        telegram-desktop
        localsend
        spotify-spotx
        libreoffice
        google-chrome
        yt-dlp
        krita
        handbrake
    ];
}
