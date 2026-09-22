{
  config,
  lib,
  ...
}:

# Wi-Fi Network Manager configuration for NixOS hosts

let
  cfg = config.my.wifi;

  sharedSecrets =
    config.my.sharedSecrets or {
      enable = false;
      file = null;
    };

  # Convert a connection name into something safe for an environment variable.
  #
  # Example:
  #   "Home Wi-Fi" -> "HOME_WIFI"
  envName =
    name: lib.toUpper (lib.replaceStrings [ " " "-" "." "/" ":" ] [ "_" "_" "_" "_" "_" ] name);

  # The password secret for a profile switches between WPA-PSK and EAP.
  passwordSecret =
    profile: if profile.eap.enable then profile.eap.passwordSecret else profile.passwordSecret;

  secretAttrs =
    profile:
    { mode = "0400"; } // lib.optionalAttrs (profile.sopsFile != null) { sopsFile = profile.sopsFile; };
in
{
  options.my.wifi = {
    enable = lib.mkEnableOption "NetworkManager Wi-Fi profiles";

    profiles = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            connectionName = lib.mkOption {
              type = lib.types.str;
              description = "NetworkManager connection name.";
            };

            ssidSecret = lib.mkOption {
              type = lib.types.str;
              default = "wifi-ssid";
              description = "Name of the SOPS secret containing this profile's SSID.";
            };

            passwordSecret = lib.mkOption {
              type = lib.types.str;
              default = "wifi-password";
              description = "SOPS secret holding the WPA-PSK passphrase.";
            };

            sopsFile = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = if sharedSecrets.enable then sharedSecrets.file else null;
              description = "Optional SOPS file override for this Wi-Fi profile.";
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
                type = lib.types.nullOr (
                  lib.types.enum [
                    "mschapv2"
                    "mschap"
                    "chap"
                    "pap"
                  ]
                );
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
        }
      );
      default = { };
      description = "Wi-Fi profiles managed by NetworkManager, keyed by connection name.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = lib.foldl' (
      secrets: profile:
      secrets
      // {
        ${profile.ssidSecret} = secretAttrs profile;
      }
      // lib.optionalAttrs (!profile.eap.enable) {
        ${profile.passwordSecret} = secretAttrs profile;
      }
      // lib.optionalAttrs profile.eap.enable {
        ${profile.eap.identitySecret} = secretAttrs profile;
        ${profile.eap.passwordSecret} = secretAttrs profile;
      }
      // lib.optionalAttrs (profile.eap.caCertSecret != null) {
        ${profile.eap.caCertSecret} = secretAttrs profile;
      }
      // lib.optionalAttrs (profile.eap.clientCertSecret != null) {
        ${profile.eap.clientCertSecret} = secretAttrs profile;
      }
      // lib.optionalAttrs (profile.eap.privateKeySecret != null) {
        ${profile.eap.privateKeySecret} = secretAttrs profile;
      }
      // lib.optionalAttrs (profile.eap.privateKeyPasswordSecret != null) {
        ${profile.eap.privateKeyPasswordSecret} = secretAttrs profile;
      }
    ) { } (lib.attrValues cfg.profiles);

    sops.templates = lib.mapAttrs' (
      connectionName: profile:
      let
        env = envName connectionName;
      in
      lib.nameValuePair "wifi-${env}-environment" {
        mode = "0400";
        content = ''
          WIFI_SSID_${env}=${config.sops.placeholder.${profile.ssidSecret}}
          WIFI_PASSWORD_${env}=${config.sops.placeholder.${passwordSecret profile}}
          ${lib.optionalString profile.eap.enable ''
            WIFI_IDENTITY_${env}=${config.sops.placeholder.${profile.eap.identitySecret}}
          ''}
          ${lib.optionalString (profile.eap.privateKeyPasswordSecret != null) ''
            WIFI_EAP_PRIVATE_KEY_PASSWORD_${env}=${
              config.sops.placeholder.${profile.eap.privateKeyPasswordSecret}
            }
          ''}
        '';
      }
    ) cfg.profiles;

    networking.networkmanager = {
      enable = true;

      ensureProfiles = {
        environmentFiles = lib.mapAttrsToList (
          connectionName: _: config.sops.templates."wifi-${envName connectionName}-environment".path
        ) cfg.profiles;

        profiles = lib.mapAttrs (
          connectionName: profile:

          let
            env = envName connectionName;
          in
          {
            connection = {
              id = connectionName;
              type = "wifi";
              autoconnect = true;
            };

            wifi = {
              mode = "infrastructure";
              ssid = "$WIFI_SSID_${env}";
            };

            ipv4 = {
              method = profile.ipv4.method;
            }
            // lib.optionalAttrs (profile.ipv4.address != null) {
              addresses = profile.ipv4.address;
            }
            // lib.optionalAttrs (profile.ipv4.gateway != null) {
              gateway = profile.ipv4.gateway;
            }
            // lib.optionalAttrs (profile.ipv4.dns != [ ]) {
              dns = lib.concatStringsSep ";" profile.ipv4.dns;
            };

            ipv6.method = "ignore";
          }
          // lib.optionalAttrs (!profile.eap.enable) {
            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = "$WIFI_PASSWORD_${env}";
              psk-flags = 0;
            };
          }
          // lib.optionalAttrs profile.eap.enable {
            "802-1x" = {
              eap = profile.eap.method;
              key-mgmt = profile.eap.keyMgmt;
              identity = "$WIFI_IDENTITY_${env}";
              identity-flags = 0;
              password = "$WIFI_PASSWORD_${env}";
              password-flags = 0;
            }
            // lib.optionalAttrs (profile.eap.phase2Auth != null) {
              phase2-auth = profile.eap.phase2Auth;
            }
            // lib.optionalAttrs (profile.eap.domain != null) {
              domain = profile.eap.domain;
            }
            // lib.optionalAttrs (profile.eap.caCertSecret != null) {
              ca-cert = config.sops.secrets.${profile.eap.caCertSecret}.path;
            }
            // lib.optionalAttrs (profile.eap.clientCertSecret != null) {
              client-cert = config.sops.secrets.${profile.eap.clientCertSecret}.path;
            }
            // lib.optionalAttrs (profile.eap.privateKeySecret != null) {
              private-key = config.sops.secrets.${profile.eap.privateKeySecret}.path;
            }
            // lib.optionalAttrs (profile.eap.privateKeyPasswordSecret != null) {
              private-key-password = "$WIFI_EAP_PRIVATE_KEY_PASSWORD_${env}";
              private-key-password-flags = 0;
            };
          }
        ) cfg.profiles;
      };
    };
  };
}
