{ pkgs, ... }:

{
  programs.google-chrome = {
    enable = true;

    nativeMessagingHosts = [
      pkgs.kdePackages.plasma-browser-integration
    ];
  };
}
