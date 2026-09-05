{ config, lib, ... }:

{
  options.my.profiles.tailscale.enable = lib.mkEnableOption "Tailscale";

  config = lib.mkIf config.my.profiles.tailscale.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };
  };
}
