{ config, lib, ... }:

let
  cfg = config.my.profiles.workstation;
in
{
  options.my.profiles.workstation = {
    enable = lib.mkEnableOption "the shared workstation configuration";
    desktop.enable = lib.mkEnableOption "desktop applications and services";
    gaming.enable = lib.mkEnableOption "gaming applications";
    videoEditing.enable = lib.mkEnableOption "video editing applications";
    tailscale.enable = lib.mkEnableOption "Tailscale";
    protonVpn.enable = lib.mkEnableOption "Proton VPN";
  };

  imports = [
    ./ssh.nix

    ../hardware
    ../features/desktop
    ../networking
    ../features/gaming
    ../features/video-editing
  ];

  config = lib.mkIf cfg.enable {
    my.features.desktop.enable = cfg.desktop.enable;
    my.features.gaming.enable = cfg.gaming.enable;
    my.features.videoEditing.enable = cfg.videoEditing.enable;
    my.features.tailscale.enable = cfg.tailscale.enable;
    my.features.protonVpn.enable = cfg.protonVpn.enable;
  };
}
