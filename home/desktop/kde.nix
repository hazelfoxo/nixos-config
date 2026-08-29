{ pkgs, ... }:

{
    # Define KDE specific applications
    home.packages = with pkgs; [

        kdePackages.kweather
    ];
}
