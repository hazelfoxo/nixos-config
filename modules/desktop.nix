{ pkgs, ... }:

{
  # Enable SDDM login manager service
  services.displayManager.sddm.enable = true;

  # Enable KDE Plasma
  services.desktopManager.plasma6.enable = true;

  # Enable Firefox Serivce
  programs.firefox.enable = true;

  # Enable Steam Service
  programs.steam.enable = true;

  # Install KDE Specific Packages
  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
  ];

}
