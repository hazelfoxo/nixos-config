{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "battery-full" ''
      echo 100 | ${pkgs.sudo}/bin/tee /sys/class/power_supply/BAT0/charge_control_end_threshold > /dev/null
    '')
  ];
}