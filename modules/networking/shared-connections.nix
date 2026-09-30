{
  config,
  lib,
  ...
}:

# Wi-Fi connections shared by the workstation hosts (my.wifi)

# Data preset, not a profile: importing this module alongside my.wifi.enable
# pulls in the home networks every workstation uses. Host-specific networks go
# into my.wifi.profiles in the host config.

{
  config = lib.mkIf config.my.wifi.enable {
    my.wifi.profiles = {
      "Home Wi-Fi" = {
        connectionName = "Home Wi-Fi";
        ssidSecret = "home-wifi-ssid";
        passwordSecret = "home-wifi-password";
      };

      "Phone Hotspot" = {
        connectionName = "Phone Hotspot";
        ssidSecret = "phone-hotspot-ssid";
        passwordSecret = "phone-hotspot-password";
        keyMgmt = "sae";
      };

      # More connections go here.
      #
      # Example: WPA-Enterprise (university / eduroam Wi-Fi)
      #
      # "School Wifi" = {
      #   connectionName = "School Wifi";
      #   ssidSecret = "school-wifi-ssid";
      #   passwordSecret = "school-wifi-password";
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
