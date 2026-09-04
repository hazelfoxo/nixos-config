{ config, lib, ... }:

let
  cfg = config.my.server.fail2ban;
in
{
  options.my.server.fail2ban.enable = lib.mkEnableOption "Fail2ban for server services";

  config = lib.mkIf cfg.enable {
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
          port = lib.concatMapStringsSep "," toString config.services.openssh.ports;
          mode = "aggressive";
        };
      };
    };
  };
}
