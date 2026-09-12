{
  config,
  lib,
  ...
}:

# Homeserver profile configuration for NixOS hosts

{
  options.my.profiles.homeserver = {
    enable = lib.mkEnableOption "SSH and WireGuard access to the homeserver";
  };

  config = lib.mkIf config.my.profiles.homeserver.enable {
    my.ssh = {
      enable = true;

      hosts.homeserver = {
        address = "10.0.0.1";
        user = "hazie";
        port = 2222;

        sopsKey = "homeserver-ssh-private-key";

        knownHostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPT/09Fl/p124dDSh7TE41JTYHPTtnZJZwR8uh67XEA root@homeserver";
      };
    };

    my.wireguard.enable = true;
  };
}
