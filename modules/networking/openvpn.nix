{ config, lib, pkgs, ... }:

let

cfg = config.my.openvpn;

shared =
config.my.sharedSecrets or {
enable = false;
file = null;
};

in

{

options.my.openvpn = {

enable = lib.mkEnableOption
  "OpenVPN profiles managed by NetworkManager";

profiles = lib.mkOption {

  type = lib.types.attrsOf (lib.types.submodule {

    options = {

      connectionName = lib.mkOption {

        type = lib.types.str;

      };

      usernameSecret = lib.mkOption {

        type = lib.types.str;

        description =
          "Name of the shared SOPS secret containing this profile's OpenVPN username.";

      };

      passwordSecret = lib.mkOption {

        type = lib.types.str;

        description =
          "Name of the shared SOPS secret containing this profile's OpenVPN password.";

      };

      sopsFile = lib.mkOption {

        type = lib.types.nullOr lib.types.path;

        default =
          if shared.enable
          then shared.file
          else null;

        description =
          "Optional SOPS file override for this OpenVPN profile.";

      };

      remote = lib.mkOption {

        type = lib.types.str;

      };

      port = lib.mkOption {

        type = lib.types.port;

        default = 1194;

      };

      protocol = lib.mkOption {

        type = lib.types.enum [ "udp" "tcp" ];

        default = "udp";

      };

      configFile = lib.mkOption {

        type = lib.types.nullOr lib.types.path;

        default = null;

      };

      caCertificate = lib.mkOption {

        type = lib.types.lines;

        default = "";

      };

      tlsAuthKey = lib.mkOption {

        type = lib.types.lines;

        default = "";

      };

      keyDirection = lib.mkOption {

        type = lib.types.enum [ 0 1 ];

        default = 1;

      };

      dataCiphers = lib.mkOption {

        type = lib.types.str;

        default =
          "AES-256-GCM:AES-128-GCM:CHACHA20-POLY1305";

      };

      dataCiphersFallback = lib.mkOption {

        type = lib.types.str;

        default = "AES-256-GCM";

      };

      auth = lib.mkOption {

        type = lib.types.str;

        default = "SHA256";

      };

      autoConnect = lib.mkOption {

        type = lib.types.bool;

        default = false;

      };

    };

  });

  default = { };

};

};

config = lib.mkIf cfg.enable {

networking.networkmanager = {

  enable = true;

  plugins = lib.mkAfter [
    pkgs.networkmanager-openvpn
  ];

};

sops.secrets =

  lib.foldl'

    (secrets: profile:

      secrets // {

        ${profile.usernameSecret} =

          {
            mode = "0400";
          }

          // lib.optionalAttrs
            (profile.sopsFile != null)
            {
              sopsFile = profile.sopsFile;
            };

        ${profile.passwordSecret} =

          {
            mode = "0400";
          }

          // lib.optionalAttrs
            (profile.sopsFile != null)
            {
              sopsFile = profile.sopsFile;
            };

      })

    { }

    (lib.attrValues cfg.profiles);

sops.templates =

  lib.mapAttrs'

    (connectionName: profile:

      lib.nameValuePair
        "openvpn-${connectionName}-environment"
        {

          mode = "0400";

          content = ''

            OPENVPN_USERNAME_${lib.toUpper connectionName}=${

              config.sops.placeholder
                .${profile.usernameSecret}

            }

          '';

        })

    cfg.profiles;

networking.networkmanager.ensureProfiles = {

  environmentFiles =

    lib.mapAttrsToList

      (connectionName: _:

        config.sops.templates
          ."openvpn-${connectionName}-environment"
          .path)

      cfg.profiles;

  secrets.entries =

    lib.mapAttrsToList

      (_: profile: {

        matchId = profile.connectionName;

        matchType = "vpn";

        matchSetting = "vpn";

        key = "password";

        file =

          config.sops.secrets
            .${profile.passwordSecret}
            .path;

      })

      cfg.profiles;

  profiles =

    lib.mapAttrs

      (connectionName: profile:

        let

          ca =

            if profile.configFile != null

            then

              pkgs.runCommand
                "openvpn-${connectionName}-ca.pem"
                { }

                ''

                  sed -n '/<ca>/,/<\/ca>/p' \
                    ${profile.configFile} \
                    | sed '1d;$d' > $out

                ''

            else

              pkgs.writeText
                "openvpn-${connectionName}-ca.pem"
                profile.caCertificate;

          ta =

            if profile.configFile != null

            then

              pkgs.runCommand
                "openvpn-${connectionName}-tls-auth.key"
                { }

                ''

                  sed -n '/<tls-auth>/,/<\/tls-auth>/p' \
                    ${profile.configFile} \
                    | sed '1d;$d' > $out

                ''

            else

              pkgs.writeText
                "openvpn-${connectionName}-tls-auth.key"
                profile.tlsAuthKey;

        in

        {

          connection = {

            id = profile.connectionName;

            type = "vpn";

            autoconnect = profile.autoConnect;

          };

          vpn = {

            service-type =
              "org.freedesktop.NetworkManager.openvpn";

            connection-type =
              "password";

            username =
              "$OPENVPN_USERNAME_${lib.toUpper connectionName}";

            password-flags = 1;

            remote = profile.remote;

            port =
              toString profile.port;

            proto-tcp =

              if profile.protocol == "tcp"

              then "yes"

              else "no";

            ca =
              toString ca;

            ta =
              toString ta;

            ta-dir =
              toString profile.keyDirection;

            auth =
              profile.auth;

            data-ciphers =
              profile.dataCiphers;

            data-ciphers-fallback =
              profile.dataCiphersFallback;

            remote-cert-tls =
              "server";

          };

          ipv4.method = "auto";

          ipv6.method = "ignore";

        })

      cfg.profiles;

};

};

}