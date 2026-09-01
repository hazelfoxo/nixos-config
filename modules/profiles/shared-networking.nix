{ config, lib, ... }:

let
  cfg = config.my.profiles.sharedNetworking;
in
{
  options.my.profiles.sharedNetworking = {
    wifi.enable = lib.mkEnableOption "the shared home Wi-Fi profile";
    schoolVpn.enable = lib.mkEnableOption "the shared school VPN profile";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.wifi.enable {
      my.wifi = {
        enable = true;
        connectionName = "Home Wi-Fi";
        ssidSecret = "home-wifi-ssid";
        passwordSecret = "home-wifi-password";
      };
    })
    (lib.mkIf cfg.schoolVpn.enable {
      my.openvpn = {
        enable = true;
        profiles.school = {
          connectionName = "School VPN";
          usernameSecret = "school-openvpn-username";
          passwordSecret = "school-openvpn-password";
          config = builtins.readFile ../../assets/openvpn/school.ovpn;
        };
      };
    })
  ];
}
