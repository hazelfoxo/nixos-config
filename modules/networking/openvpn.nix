{ config, lib, pkgs, ... }:

let
  cfg = config.my.openvpn;
  sharedSecrets = config.my.sharedSecrets or {
    enable = false;
    file = null;
  };
  nmcli = "${config.networking.networkmanager.package}/bin/nmcli";
in
{
  options.my.openvpn = {
    enable = lib.mkEnableOption "OpenVPN profiles managed by NetworkManager";

    profiles = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
        options = {
          config = lib.mkOption {
            type = lib.types.lines;
            description = ''
              Complete OpenVPN configuration in .ovpn format. Inline blocks such
              as <ca> and <tls-auth> are supported. Include `auth-user-pass`
              without a filename; NetworkManager receives the credentials from
              the SOPS secrets configured below.
            '';
          };

          connectionName = lib.mkOption {
            type = lib.types.str;
            default = name;
            description = "Name displayed for this profile in NetworkManager.";
          };

          usernameSecret = lib.mkOption {
            type = lib.types.str;
            description = "Name of the SOPS secret containing the VPN username.";
          };

          passwordSecret = lib.mkOption {
            type = lib.types.str;
            description = "Name of the SOPS secret containing the VPN password.";
          };
          sopsFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = if sharedSecrets.enable then sharedSecrets.file else null;
          };

          autoConnect = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether NetworkManager should automatically activate this VPN.";
          };
        };
      }));
      default = { };
      description = "OpenVPN profiles keyed by a stable import name.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;
      plugins = lib.mkAfter [ pkgs.networkmanager-openvpn ];

      ensureProfiles.secrets.entries = lib.mapAttrsToList
        (_: profile: {
          matchId = profile.connectionName;
          matchType = "vpn";
          matchSetting = "vpn";
          key = "password";
          file = config.sops.secrets.${profile.passwordSecret}.path;
        })
        cfg.profiles;
    };

    sops.secrets = lib.foldl'
      (secrets: profile:
        secrets // {
          ${profile.usernameSecret} = { mode = "0400"; } // lib.optionalAttrs (profile.sopsFile != null) { sopsFile = profile.sopsFile; };
          ${profile.passwordSecret} = { mode = "0400"; } // lib.optionalAttrs (profile.sopsFile != null) { sopsFile = profile.sopsFile; };
        })
      { }
      (lib.attrValues cfg.profiles);

    systemd.services = lib.mapAttrs'
      (name: profile:
        let
          ovpnFile = pkgs.writeText "${name}.ovpn" profile.config;
          runtimeConfig = "/run/openvpn/${name}.ovpn";
          importName = lib.escapeShellArg name;
          connectionName = lib.escapeShellArg profile.connectionName;
        in
        lib.nameValuePair "networkmanager-openvpn-${name}" {
          description = "Create NetworkManager OpenVPN profile ${profile.connectionName}";
          wantedBy = [ "multi-user.target" ];
          requires = [ "NetworkManager.service" "sops-nix.service" "nm-file-secret-agent.service" ];
          after = [ "NetworkManager.service" "sops-nix.service" "nm-file-secret-agent.service" ];
          restartTriggers = [ ovpnFile ];

          script = ''
            ${pkgs.coreutils}/bin/install -d -m 0700 /run/openvpn
            ${pkgs.coreutils}/bin/install -m 0600 ${ovpnFile} ${lib.escapeShellArg runtimeConfig}

            # The profile is managed at runtime, so remove an earlier copy before importing it.
            ${nmcli} connection delete id ${connectionName} 2>/dev/null || true
            ${nmcli} connection delete id ${importName} 2>/dev/null || true
            ${nmcli} --wait 10 connection import --temporary type openvpn file ${lib.escapeShellArg runtimeConfig}
            ${nmcli} connection modify --temporary id ${importName} \
              connection.id ${connectionName} \
              connection.autoconnect ${if profile.autoConnect then "yes" else "no"} \
              vpn.user-name "$(< ${config.sops.secrets.${profile.usernameSecret}.path})"
          '';

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            UMask = "0077";
          };
        })
      cfg.profiles;
  };
}
