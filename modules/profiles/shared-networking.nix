{ config, lib, ... }:

let
  cfg = config.my.profiles.sharedNetworking;
in
{
  # This profile owns the modules it configures so it works independently of
  # the workstation profile's client networking bundle (each module is thus
  # imported exactly once per host).
  imports = [
    ../networking/wifi.nix
    ../networking/openvpn.nix
  ];

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
          remote = "vpn.chester.ac.uk";
          port = 1195;
          protocol = "udp";
          configFile = ../../assets/openvpn/school.ovpn;
        };
      };
    })
  ];
}
