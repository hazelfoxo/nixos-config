{ config, lib, ... }:

# Wi-Fi Network Manager configuration for NixOS hosts

let
  cfg = config.my.wifi;
  sharedSecrets =
    config.my.sharedSecrets or {
      enable = false;
      file = null;
    };
  secretAttrs =
    { mode = "0400"; }
    // lib.optionalAttrs (cfg.sopsFile != null) { sopsFile = cfg.sopsFile; };
  passwordSecret = if cfg.eap.enable then cfg.eap.passwordSecret else cfg.passwordSecret;
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
      description = "SOPS secret holding the WPA-PSK passphrase.";
    };
    sopsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = if sharedSecrets.enable then sharedSecrets.file else null;
    };
    eap = {
      enable = lib.mkEnableOption "802-1x (WPA-Enterprise) authentication";
      method = lib.mkOption {
        type = lib.types.enum [
          "tls"
          "pwd"
          "leap"
          "peap"
          "ttls"
        ];
        default = "peap";
        description = "EAP method to use (tls, pwd, leap, peap, ttls).";
      };
      identitySecret = lib.mkOption {
        type = lib.types.str;
        default = "wifi-identity";
        description = "SOPS secret holding the EAP username.";
      };
      passwordSecret = lib.mkOption {
        type = lib.types.str;
        default = "wifi-password";
        description = "SOPS secret holding the EAP password.";
      };
      phase2Auth = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [
          "mschapv2"
          "mschap"
          "chap"
          "pap"
        ]);
        default = null;
        description = "Inner authentication for peap/ttls (e.g. mschapv2).";
      };
      domain = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Server domain suffix match (802-1x.domain).";
      };
      keyMgmt = lib.mkOption {
        type = lib.types.str;
        default = "wpa-eap";
        description = "key-mgmt for the 802-1x profile (wpa-eap, or ieee8021x for legacy LEAP).";
      };
      caCertSecret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "SOPS secret holding a PEM CA certificate.";
      };
      clientCertSecret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "SOPS secret holding a PEM client certificate (required for tls).";
      };
      privateKeySecret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "SOPS secret holding a PEM client private key (required for tls).";
      };
      privateKeyPasswordSecret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "SOPS secret holding the client private key password.";
      };
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
    sops.secrets =
      {
        ${cfg.ssidSecret} = secretAttrs;
      }
      // lib.optionalAttrs (!cfg.eap.enable) {
        ${cfg.passwordSecret} = secretAttrs;
      }
      // lib.optionalAttrs cfg.eap.enable {
        ${cfg.eap.identitySecret} = secretAttrs;
        ${cfg.eap.passwordSecret} = secretAttrs;
      }
      // lib.optionalAttrs (cfg.eap.caCertSecret != null) {
        ${cfg.eap.caCertSecret} = secretAttrs;
      }
      // lib.optionalAttrs (cfg.eap.clientCertSecret != null) {
        ${cfg.eap.clientCertSecret} = secretAttrs;
      }
      // lib.optionalAttrs (cfg.eap.privateKeySecret != null) {
        ${cfg.eap.privateKeySecret} = secretAttrs;
      }
      // lib.optionalAttrs (cfg.eap.privateKeyPasswordSecret != null) {
        ${cfg.eap.privateKeyPasswordSecret} = secretAttrs;
      };

    sops.templates.wifi-environment = {
      mode = "0400";
      content = ''
        WIFI_SSID=${config.sops.placeholder.${cfg.ssidSecret}}
        WIFI_PASSWORD=${config.sops.placeholder.${passwordSecret}}
        ${lib.optionalString cfg.eap.enable ''
          WIFI_IDENTITY=${config.sops.placeholder.${cfg.eap.identitySecret}}
        ''}
        ${lib.optionalString (cfg.eap.privateKeyPasswordSecret != null) ''
          WIFI_EAP_PRIVATE_KEY_PASSWORD=${config.sops.placeholder.${cfg.eap.privateKeyPasswordSecret}}
        ''}
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
        }
        // lib.optionalAttrs (!cfg.eap.enable) {
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$WIFI_PASSWORD";
            psk-flags = 0;
          };
        }
        // lib.optionalAttrs cfg.eap.enable {
          "802-1x" = {
            eap = cfg.eap.method;
            key-mgmt = cfg.eap.keyMgmt;
            identity = "$WIFI_IDENTITY";
            identity-flags = 0;
            password = "$WIFI_PASSWORD";
            password-flags = 0;
          }
          // lib.optionalAttrs (cfg.eap.phase2Auth != null) {
            phase2-auth = cfg.eap.phase2Auth;
          }
          // lib.optionalAttrs (cfg.eap.domain != null) {
            domain = cfg.eap.domain;
          }
          // lib.optionalAttrs (cfg.eap.caCertSecret != null) {
            ca-cert = config.sops.secrets.${cfg.eap.caCertSecret}.path;
          }
          // lib.optionalAttrs (cfg.eap.clientCertSecret != null) {
            client-cert = config.sops.secrets.${cfg.eap.clientCertSecret}.path;
          }
          // lib.optionalAttrs (cfg.eap.privateKeySecret != null) {
            private-key = config.sops.secrets.${cfg.eap.privateKeySecret}.path;
          }
          // lib.optionalAttrs (cfg.eap.privateKeyPasswordSecret != null) {
            private-key-password = "$WIFI_EAP_PRIVATE_KEY_PASSWORD";
            private-key-password-flags = 0;
          };
        };
      };
    };
  };
}