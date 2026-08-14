{ pkgs, ... }:

{
    # Define KDE specific applications
    home.packages = with pkgs; [
        kdePackages.kate
        haruna
        kdePackages.kweather
    ];
}
