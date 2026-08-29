{ config, lib, ... }:

let
cfg = config.my.ssh;

hostsWithKnownKeys = lib.filterAttrs (
_: hostCfg: hostCfg.knownHostKey != null
) cfg.hosts;

in
{
options.my.ssh = {
enable = lib.mkEnableOption "SSH client configuration";

owner = lib.mkOption {
  type = lib.types.str;
  description = "Local user who should own the SSH private keys.";
};

group = lib.mkOption {
  type = lib.types.str;
  default = "users";
  description = "Group that should own the SSH private keys.";
};

hosts = lib.mkOption {
  type = lib.types.attrsOf (
    lib.types.submodule {
      options = {
        address = lib.mkOption {
          type = lib.types.str;
          description = "Hostname or IP address of the remote server.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 22;
          description = "SSH port of the remote server.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          description = "SSH username on the remote server.";
        };

        sopsKey = lib.mkOption {
          type = lib.types.str;
          description = "Name of the SOPS secret containing the SSH private key.";
        };

        knownHostKey = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "SSH public host key.";
        };

        extraConfig = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = "Additional SSH configuration for this host.";
        };
      };
    }
  );

  default = { };

  description = ''
    SSH hosts to configure.

    The attribute name is used as the SSH alias.
  '';
};

};

config = lib.mkIf cfg.enable {
sops.secrets = lib.mapAttrs' (
_: hostCfg:
lib.nameValuePair hostCfg.sopsKey {
owner = cfg.owner;
group = cfg.group;
mode = "0400";
}
) cfg.hosts;

programs.ssh.extraConfig =
  lib.concatStringsSep "\n"
    (
      lib.mapAttrsToList (
        name: hostCfg:
        ''
          Host ${name}
            HostName ${hostCfg.address}
            Port ${toString hostCfg.port}
            User ${hostCfg.user}
            IdentityFile ${config.sops.secrets.${hostCfg.sopsKey}.path}
            IdentitiesOnly yes
            AddKeysToAgent yes
            ${hostCfg.extraConfig}
        ''
      )
      cfg.hosts
    );

programs.ssh.knownHosts = lib.mapAttrs (
  _: hostCfg:
  {
    hostNames = [
      hostCfg.address
      "[${hostCfg.address}]:${toString hostCfg.port}"
    ];

    publicKey = hostCfg.knownHostKey;
  }
) hostsWithKnownKeys;

};
}
