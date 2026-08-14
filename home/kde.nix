{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.kate
    haruna
    kdePackages.kweather
  ];
}
