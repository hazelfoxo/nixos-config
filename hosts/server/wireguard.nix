{ config, ... }:

let
  laptopPublicKey = "LIraGHV+u4GN8QNSMo8MhOtX/sDQecQ/w9uY57H+sl4=";
  iPhonePublicKey = "11Se4L5MQu39OOU0f372f5lkeeI78oUkCTbVN4jgxno=";
  desktopPublicKey = "mbY8t2dV3wF9P+R/IWq9k5p2aEIkTKz4VxwJmUYUhWo=";
in
{
  # The private key is stored encrypted in secrets/hosts/server.yaml.  Do not
  # put the key directly in this file.
  sops = {
    defaultSopsFile = ../../secrets/hosts/server.yaml;
    age.keyFile = "/var/lib/sops-nix/device-key.txt";

    secrets.wireguard-server-private-key = {
      owner = "root";
      group = "root";
      mode = "0400";
    };
  };

  networking = {
    wg-quick.interfaces.wg0 = {
      # This is the address already used by the desktop and laptop profiles.
      address = [ "10.0.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = config.sops.secrets.wireguard-server-private-key.path;

      peers = [
        {
          publicKey = laptopPublicKey;
          allowedIPs = [ "10.0.0.2/32" ];
        }
        {
          publicKey = iPhonePublicKey;
          allowedIPs = [ "10.0.0.3/32" ];
        }
        {
          publicKey = desktopPublicKey;
          allowedIPs = [ "10.0.0.4/32" ];
        }
      ];
    };
  };

  # Declarative equivalent of the supplied PostUp forwarding command. NAT is
  # intentionally not enabled, because clients currently route only 10.0.0.1.
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
