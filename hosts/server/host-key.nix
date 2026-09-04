{ config, lib, ... }:

let
  cfg = config.my.server.hostKey;
in
{
  options.my.server.hostKey.enable = lib.mkEnableOption "restore the server SSH host key from SOPS";

  # Secrets and SOPS defaults come from the shared core; this file only
  # wires the restored host key into OpenSSH.
  config = lib.mkIf cfg.enable {
    sops.secrets.ssh-host-ed25519 = {
      owner = "root";
      group = "root";
      mode = "0600";
    };

    services.openssh = {
      generateHostKeys = false;
      hostKeys = [
        {
          type = "ed25519";
          path = config.sops.secrets.ssh-host-ed25519.path;
        }
      ];
    };

    systemd.services.sshd = {
      after = [ "sops-nix.service" ];
      requires = [ "sops-nix.service" ];
    };
  };
}
