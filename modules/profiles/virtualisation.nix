{
  config,
  lib,
  pkgs,
  ...
}:

# Virtualisation profile configuration for NixOS hosts

# Enables the libvirt daemon with KVM/QEMU and TPM (swtpm) support,
# plus the virt-manager GUI for managing virtual machines.

{
  options.my.profiles.virtualisation.enable = lib.mkEnableOption "the virtualisation profile";

  config = lib.mkIf config.my.profiles.virtualisation.enable {
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
  };
}
