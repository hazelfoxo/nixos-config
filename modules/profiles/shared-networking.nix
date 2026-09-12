{ config, lib, ... }:

let
  cfg = config.my.profiles.sharedNetworking;
in
{
  # The WiFi and OpenVPN modules themselves are imported once by the shared
  # profiles layer; this profile only configures them.
  options.my.profiles.sharedNetworking = {
    wifi.enable = lib.mkEnableOption "the shared home Wi-Fi profile";

    homeserverSsh.enable = lib.mkEnableOption "SSH access to the homeserver";
  };

  config = lib.mkIf (cfg.wifi.enable || cfg.homeserverSsh.enable) {
    my.wifi = lib.mkIf cfg.wifi.enable {
      enable = true;
      connectionName = "Home Wi-Fi";
      ssidSecret = "home-wifi-ssid";
      passwordSecret = "home-wifi-password";
    };

    my.ssh = lib.mkIf cfg.homeserverSsh.enable {
      enable = true;

      hosts.homeserver = {
        address = "10.0.0.1";
        user = "hazie";
        port = 2222;

        sopsKey = "homeserver-ssh-private-key";

        knownHostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPT/09Fl/p124dDSh7TE41JTYHPTtnZJZwR8uh67XEA root@homeserver";
      };
    };
  };
}
