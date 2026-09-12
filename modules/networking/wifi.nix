{ config, lib, ... }:

# Wi-Fi Network Manager configuration for NixOS hosts

let
  cfg = config.my.wifi;
  sharedSecrets =
    config.my.sharedSecrets or {
      enable = false;
      file = null;
    };
in
{
  options.my.wifi = {
    enable = lib.mkEnableOption "a NetworkManager Wi-Fi profile";
    connectionName = lib.mkOption {
      type = lib.types.str;
      default = "Home Wi-Fi";
    };
    ssidSecret = lib.mkOption {
      type = lib.types.str;
      default = "wifi-ssid";
    };
    passwordSecret = lib.mkOption {
      type = lib.types.str;
      default = "wifi-password";
    };
    sopsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = if sharedSecrets.enable then sharedSecrets.file else null;
    };
    ipv4 = {
      method = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "manual"
        ];
        default = "auto";
      };
      address = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      gateway = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      dns = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      ${cfg.ssidSecret} = {
        mode = "0400";
      }
      // lib.optionalAttrs (cfg.sopsFile != null) { sopsFile = cfg.sopsFile; };
      ${cfg.passwordSecret} = {
        mode = "0400";
      }
      // lib.optionalAttrs (cfg.sopsFile != null) { sopsFile = cfg.sopsFile; };
    };

    sops.templates.wifi-environment = {
      mode = "0400";
      content = ''
        WIFI_SSID=${config.sops.placeholder.${cfg.ssidSecret}}
        WIFI_PASSWORD=${config.sops.placeholder.${cfg.passwordSecret}}
      '';
    };

    networking.networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [ config.sops.templates.wifi-environment.path ];
        profiles.${cfg.connectionName} = {
          connection = {
            id = cfg.connectionName;
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
            method = cfg.ipv4.method;
          }
          // lib.optionalAttrs (cfg.ipv4.address != null) {
            addresses = cfg.ipv4.address;
          }
          // lib.optionalAttrs (cfg.ipv4.gateway != null) {
            gateway = cfg.ipv4.gateway;
          }
          // lib.optionalAttrs (cfg.ipv4.dns != [ ]) {
            dns = lib.concatStringsSep ";" cfg.ipv4.dns;
          };
          ipv6.method = "ignore";
        };
      };
    };
  };
}
