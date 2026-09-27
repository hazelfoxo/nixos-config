{
  config,
  lib,
  pkgs,
  ...
}:

# Homeserver profile configuration for NixOS hosts

{
  options.my.profiles.homeserver = {
    enable = lib.mkEnableOption "SSH and Tailscale access to the homeserver";
  };

  config = lib.mkIf config.my.profiles.homeserver.enable {
      my.ssh = {
        enable = true;

        hosts.homeserver = {
          address = "homeserver";
          user = "hazie";
          port = 22;

          sopsKey = "homeserver-ssh-private-key";

          knownHostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPT/09Fl/p124dDSh7TE41JTYHPTtnZJZwR8uh67XEA root@homeserver";
        };
      };

    my.profiles.tailscale.enable = true;

    environment.systemPackages = with pkgs; [
      sshfs
    ];
  };
}
