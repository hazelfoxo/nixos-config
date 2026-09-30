{
  config,
  lib,
  pkgs,
  ...
}:

# Virtualisation profile configuration for NixOS hosts

let
  cfg = config.my.profiles.virtualisation;
in
{
  options.my.profiles.virtualisation = {
    enable = lib.mkEnableOption "the virtualisation profile";

    waydroid.enable = lib.mkEnableOption "waydroid";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
        };
      };

      environment.systemPackages = with pkgs; [
        virt-manager
        virt-viewer
      ];
    })

    (lib.mkIf cfg.waydroid.enable {
      virtualisation.waydroid = {
        enable = true;

        # Newer kernel versions may need the nftables backend.
        package = pkgs.waydroid-nftables;
      };

      # Clipboard sharing between the host and the container.
      environment.systemPackages = [ pkgs.wl-clipboard ];
    })
  ];
}
