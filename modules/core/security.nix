{ ... }:

{
  networking.firewall.enable = true;

  security = {
    apparmor.enable = true;

    # Only administrators explicitly placed in the wheel group may use sudo.
    sudo.execWheelOnly = true;
  };

  # Avoid retaining potentially sensitive process memory after a crash.
  systemd.coredump.enable = false;

  # Reduce the amount of useful kernel information exposed to unprivileged
  # local users. Network-related sysctls intentionally stay unchanged to keep
  # the existing VPN and WireGuard setup compatible.
  boot.kernel.sysctl = {
    "fs.protected_fifos" = 2;
    "fs.protected_hardlinks" = 1;
    "fs.protected_regular" = 2;
    "fs.protected_symlinks" = 1;
    "kernel.dmesg_restrict" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.yama.ptrace_scope" = 1;
  };

  # These apply when an SSH server is enabled later; SSH remains disabled by
  # default in the minimal server profile.
  services.openssh.settings = {
    KbdInteractiveAuthentication = false;
    PasswordAuthentication = false;
    PermitRootLogin = "no";
    X11Forwarding = false;
  };
}
