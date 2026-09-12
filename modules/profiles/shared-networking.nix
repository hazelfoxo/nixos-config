{ config, lib, ... }:

let
  cfg = config.my.profiles.sharedNetworking;
in
{
  options.my.profiles.sharedNetworking = {
    wifi.enable = lib.mkEnableOption "the shared home Wi-Fi profile";
  };

  config = lib.mkIf cfg.wifi.enable {
    my.wifi = {
      enable = true;
      connectionName = "Home Wi-Fi";
      ssidSecret = "home-wifi-ssid";
      passwordSecret = "home-wifi-password";
    };
  };
}
