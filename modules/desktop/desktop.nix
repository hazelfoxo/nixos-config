{ pkgs, ... }:

{
  # Enable SDDM login manager service
  services.displayManager.sddm.enable = true;

  # Enable KDE Plasma
  services.desktopManager.plasma6.enable = true;

  # Install KDE Specific Packages
  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
  ];

  # Enable XDG Portal
  xdg.portal.enable = true;

   # Enable Flatpak Service
  services.flatpak.enable = true;

  # Enable KDE Partition Manager
  programs.partition-manager.enable = true;
}
