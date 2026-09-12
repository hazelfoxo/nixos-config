{ config, lib, ... }:

# SSH server configuration for NixOS Server hosts

let
  cfg = config.my.server.ssh;
in
{
  options.my.server.ssh = {
    enable = lib.mkEnableOption "a hardened SSH server";
    port = lib.mkOption {
      type = lib.types.port;
      default = 2222;
    };
    allowedUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = false;
      ports = [ cfg.port ];
      settings = {
        AllowUsers = cfg.allowedUsers;
        PermitRootLogin = "no";
        MaxAuthTries = 3;
        PubkeyAuthentication = true;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
        PrintMotd = false;
        ClientAliveInterval = 100;
        ClientAliveCountMax = 3;
      };
    };
  };
}
