{ config, lib, pkgs, ... }:

lib.mkIf config.my.features.desktop.kde.enable {
  # Enable SDDM login manager service
  services.displayManager.sddm.enable = true;

  # Enable KDE Plasma
  services.desktopManager.plasma6.enable = true;

  # Install KDE Specific Packages
  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
    kdePackages.kate
    kdePackages.kcalc
    haruna
  ];

  # Enable KDE Partition Manager
  programs.partition-manager.enable = true;
}
