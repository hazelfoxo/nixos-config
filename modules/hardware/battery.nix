{ config, lib, ... }:

# Battery & power management for battery-backed hosts.

let
  cfg = config.my.hardware.battery;
in
{
  options.my.hardware.battery = {
    enable = lib.mkEnableOption "battery-aware power management";

    sleep.hibernateDelaySec = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "1h";
      description = "Delay before suspend-then-hibernate kicks in (systemd HibernateDelaySec).";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.sleep.settings.Sleep = {
      HibernateDelaySec = cfg.sleep.hibernateDelaySec;
    };
  };
}