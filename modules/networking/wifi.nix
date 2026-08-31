{ config, lib, ... }:

let
  cfg = config.my.server.wifi;
in
{
  options.my.server.wifi = {
    enable = lib.mkEnableOption "a NetworkManager Wi-Fi profile";
    connectionName = lib.mkOption { type = lib.types.str; default = "Home Wi-Fi"; };
    ssidSecret = lib.mkOption { type = lib.types.str; default = "wifi-ssid"; };
    passwordSecret = lib.mkOption { type = lib.types.str; default = "wifi-password"; };
    address = lib.mkOption { type = lib.types.str; };
    gateway = lib.mkOption { type = lib.types.str; };
    dns = lib.mkOption { type = lib.types.listOf lib.types.str; default = [ ]; };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      ${cfg.ssidSecret}.mode = "0400";
      ${cfg.passwordSecret}.mode = "0400";
    };

    sops.templates.server-wifi-environment = {
      mode = "0400";
      content = ''
        WIFI_SSID=${config.sops.placeholder.${cfg.ssidSecret}}
        WIFI_PASSWORD=${config.sops.placeholder.${cfg.passwordSecret}}
      '';
    };

    networking.networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [ config.sops.templates.server-wifi-environment.path ];
        profiles.${cfg.connectionName} = {
          connection = {
            id = cfg.connectionName;
            type = "wifi";
            autoconnect = true;
          };
          wifi = { mode = "infrastructure"; ssid = "$WIFI_SSID"; };
          wifi-security = { key-mgmt = "wpa-psk"; psk = "$WIFI_PASSWORD"; psk-flags = 0; };
          ipv4 = {
            method = "manual";
            addresses = cfg.address;
            gateway = cfg.gateway;
            dns = lib.concatStringsSep ";" cfg.dns;
          };
          ipv6.method = "ignore";
        };
      };
    };
  };
}
