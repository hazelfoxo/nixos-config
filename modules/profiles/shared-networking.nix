{ config, lib, ... }:

let
  cfg = config.my.profiles.sharedNetworking;
in
{
  # The WiFi and OpenVPN modules themselves are imported once by the shared
  # profiles layer; this profile only configures them.
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
          neverDefault = true;
        };
      };

      my.ssh.hosts."git.chester.network" = {
        address = "git.chester.network";
        user = "git";
        sopsKey = "school-gitlab-ssh-private-key";
        knownHostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH01CaONW6JX9VW6m7DpCJvNkBM4ndbAWJu+V4QduVex";
      };
    })
  ];
}
