{
  config,
  lib,
  pkgs,
  ...
}:

# Secrets configuration for NixOS hosts

let
  cfg = config.my.secrets;
in
{

  options.my.secrets = {

    secretsUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        User that runs nm-file-secret-agent and owns secrets that must
        be accessible to user-level NetworkManager secret requests.

        Leave unset on hosts that do not provide VPN secrets to
        NetworkManager; the file secret agent is only defined when this
        is set.
      '';
    };

  };

  config = lib.mkMerge [

    {
      environment.systemPackages = [
        pkgs.sops
      ];

      sops.age.keyFile = "/var/lib/sops-nix/device-key.txt";
    }

    # Make nm-file-secret-agent run as the configured secrets user.
    (lib.mkIf (cfg.secretsUser != null) {
      systemd.services.nm-file-secret-agent.serviceConfig = {
        User = cfg.secretsUser;
        Group = "users";
      };
    })

  ];

}
