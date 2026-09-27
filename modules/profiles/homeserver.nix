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
    programs.ssh.knownHosts.homeserver = {
      hostNames = [
        "homeserver"
        "homeserver.taila3232f.ts.net"
        "100.85.25.56"
      ];

      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPT/09Fl/p124dDSh7TE41JTYHPTtnZJZwR8uh67XEA";
    };

    my.profiles.tailscale.enable = true;

    environment.systemPackages = with pkgs; [
      sshfs
    ];
  };
}
