{ osConfig, pkgs, lib, ... }:

# Enable Google Chrome and configure its settings

{
  programs.google-chrome = {
    enable = true;

    # Enable native messaging hosts for KDE Plasma integration if KDE is enabled
    nativeMessagingHosts = lib.optional
      osConfig.my.profiles.desktop.kde.enable
    pkgs.kdePackages.plasma-browser-integration;
  };
}
