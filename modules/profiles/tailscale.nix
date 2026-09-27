{ config, lib, ... }:

# Tailscale profile configuration for NixOS hosts

{
  options.my.profiles.tailscale.enable = lib.mkEnableOption "Tailscale";

  config = lib.mkIf config.my.profiles.tailscale.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;

      # Let the user drive tailscaled through its local API socket without
      # sudo: tailscale status/set/up, the tailscale-systray desktop entry,
      # and anything else that talks to the daemon.
      extraSetFlags = [ "--operator=${config.users.users.hazie.name}" ];
    };
  };
}
