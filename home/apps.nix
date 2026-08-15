{ pkgs, ... }:

{
    # Define user programs and applications
    home.packages = with pkgs; [
        discord
        telegram-desktop
        spotify
        localsend
        pkgs."spotify-adblock"
        libreoffice
        mprisence
    ];
}
