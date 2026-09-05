{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.profiles.protonVpn.enable = lib.mkEnableOption "Proton VPN";

  config = lib.mkIf config.my.profiles.protonVpn.enable {
    networking.firewall.checkReversePath = false;

    environment.systemPackages = with pkgs; [
      proton-vpn
    ];
  };
}
