{ ... }:

{
  # Enable NixOS firewall
  networking.firewall.enable = true;

  security = {
    # Enable AppArmor
    apparmor.enable = true;
    # Explicity restrict sudo to users in sudo wheel
    sudo.execWheelOnly = true;
  };

  # Disable coredump
  systemd.coredump.enable = false;

  # Make some kernel info read-only by root
  boot.kernel.sysctl = {
    "fs.protected_fifos" = 2;
    "fs.protected_hardlinks" = 1;
    "fs.protected_regular" = 2;
    "fs.protected_symlinks" = 1;
    "kernel.dmesg_restrict" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.yama.ptrace_scope" = 1;
  };

  # SSH server settings
  services.openssh.settings = {
    KbdInteractiveAuthentication = false;
    PasswordAuthentication = false;
    PermitRootLogin = "no";
    X11Forwarding = false;
  };
}
