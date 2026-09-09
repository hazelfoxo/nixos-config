{ osConfig, pkgs, lib, ... }:

{
  programs.google-chrome = {
    enable = true;

    nativeMessagingHosts = lib.optional
      osConfig.my.profiles.desktop.kde.enable
    pkgs.kdePackages.plasma-browser-integration;
  };
}
