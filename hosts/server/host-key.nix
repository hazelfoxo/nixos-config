{ config, inputs, lib, ... }:

let
  cfg = config.my.server.hostKey;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.my.server.hostKey.enable = lib.mkEnableOption
    "restore the server SSH host key from SOPS";

  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = ../../secrets/hosts/server.yaml;
      age.keyFile = "/var/lib/sops-nix/device-key.txt";

      secrets.ssh-host-ed25519 = {
        owner = "root";
        group = "root";
        mode = "0600";
      };
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
