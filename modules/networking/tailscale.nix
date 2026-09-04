{ config, lib, ... }:

let
  cfg = config.my.features.tailscale;
in
{
  options.my.features.tailscale.enable = lib.mkEnableOption "Tailscale";

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };
  };
}
