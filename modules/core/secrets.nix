{ config, lib, pkgs, ... }:

let
  cfg = config.my.secrets;
in
{

  options.my.secrets = {

    secretsUser = lib.mkOption {
      type = lib.types.str;
      description = ''
        User that runs nm-file-secret-agent and owns secrets that must
        be accessible to user-level NetworkManager secret requests.
      '';
    };

  };

  config = {

    environment.systemPackages = [
      pkgs.sops
    ];

    sops.age.keyFile = "/var/lib/sops-nix/device-key.txt";

    # Make nm-file-secret-agent run as the configured secrets user.
    systemd.services.nm-file-secret-agent.serviceConfig = {
      User = cfg.secretsUser;
      Group = "users";
    };

  };

}