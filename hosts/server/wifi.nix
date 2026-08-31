{ config, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/hosts/server.yaml;
    age.keyFile = "/var/lib/sops-nix/device-key.txt";

    secrets.wifi-password = {
      owner = "root";
      group = "root";
      mode = "0400";
    };

    secrets.wifi-ssid = {
      owner = "root";
      group = "root";
      mode = "0400";
    };

    templates.server-wifi-password-env = {
      owner = "root";
      group = "root";
      mode = "0400";
      content = ''
        WIFI_SSID=${config.sops.placeholder.wifi-ssid}
        WIFI_PASSWORD=${config.sops.placeholder.wifi-password}
      '';
    };
  };

  networking.networkmanager = {
    enable = true;

    ensureProfiles = {
      environmentFiles = [ config.sops.templates.server-wifi-password-env.path ];

      profiles.HomeWiFi = {
        connection = {
          id = "Home Wi-Fi";
          type = "wifi";
          autoconnect = true;
        };

        wifi = {
          mode = "infrastructure";
          ssid = "$WIFI_SSID";
        };

        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$WIFI_PASSWORD";
          psk-flags = 0;
        };

        ipv4 = {
          method = "manual";
          addresses = "192.168.1.200/24";
          gateway = "192.168.1.1";
          dns = "1.1.1.1;9.9.9.9";
        };

        ipv6.method = "ignore";
      };
    };
  };
}
