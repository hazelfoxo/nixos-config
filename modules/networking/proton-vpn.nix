{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.features.protonVpn;
in
{
  options.my.features.protonVpn.enable = lib.mkEnableOption "Proton VPN";

  config = lib.mkIf cfg.enable {
    networking.firewall.checkReversePath = false;

    environment.systemPackages = with pkgs; [
      proton-vpn
    ];
  };
}
