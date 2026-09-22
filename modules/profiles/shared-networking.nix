{ config, lib, ... }:

# Shared Networking for NixOS hosts

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

      profiles."Home Wi-Fi" = {
        connectionName = "Home Wi-Fi";
        ssidSecret = "home-wifi-ssid";
        passwordSecret = "home-wifi-password";
      };

      profiles."Phone Hotspot" = {
        connectionName = "Phone Hotspot";
        ssidSecret = "phone-hotspot-ssid";
        passwordSecret = "phone-hotspot-password";
      };

      # More connections go here.
      #
      # Example: WPA-Enterprise (university / eduroam Wi-Fi)
      #
      # profiles."School Wifi" = {
      #   connectionName = "School Wifi";
      #   ssidSecret = "school-wifi-ssid";
      #   eap = {
      #     enable = true;
      #     method = "peap";
      #     identitySecret = "school-wifi-identity";
      #     passwordSecret = "school-wifi-password";
      #     phase2Auth = "mschapv2";
      #   };
      # };
    };
  };
}
