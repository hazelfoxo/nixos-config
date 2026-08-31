{ ... }:

{
  # SSH is available only through WireGuard, but this additionally bans a VPN
  # peer after repeated failed authentication attempts.
  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "1h";

    bantime-increment = {
      enable = true;
      maxtime = "24h";
    };

    jails = {
      DEFAULT.settings.findtime = "10m";

      sshd.settings = {
        enabled = true;
        port = "2222";
        mode = "aggressive";
      };
    };
  };
}
