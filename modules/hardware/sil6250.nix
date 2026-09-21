{
  config,
  lib,
  pkgs,
  ...
}:

# sil6250 fingerprint stack for Huawei hosts:
#   - sil6250.ko kernel module (ACPI platform driver exposing /dev/sil6250)
#   - sil6250d daemon (registers the device with open-fprintd over D-Bus)
#   - open-fprintd (fprintd-compatible manager owning net.reactivated.Fprint)

let
  sil6250 = config.boot.kernelPackages.callPackage (
    { stdenv, kernel }:

    stdenv.mkDerivation {
      pname = "sil6250";
      version = "0.1.0";

      src = config.my.inputs.sil6250Linux;
      sourceRoot = "source/kernel";

      nativeBuildInputs = kernel.moduleBuildDependencies;

      makeFlags = [
        "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      ];

      installPhase = ''
        mkdir -p "$out/lib/modules/${kernel.modDirVersion}/extra"
        cp sil6250.ko \
          "$out/lib/modules/${kernel.modDirVersion}/extra/"
      '';

      meta.license = lib.licenses.lgpl21;
    }
  ) { };

  sil6250d = pkgs.rustPlatform.buildRustPackage {
    pname = "sil6250d";
    version = "0.1.0";

    src = config.my.inputs.sil6250Linux;

    cargoLock.lockFile = config.my.inputs.sil6250Linux + "/Cargo.lock";
    cargoBuildFlags = [
      "-p"
      "sil6250d"
    ];

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.openssl ];

    meta.license = lib.licenses.lgpl21;
  };

  openFprintd = pkgs.open-fprintd;

  # D-Bus policy letting sil6250d own io.github.uunicorn.Fprint and open-fprintd
  # (also root) call its device interface.
  sil6250dDBusConf = pkgs.writeTextFile {
    name = "io.github.uunicorn.Fprint.conf";
    destination = "/share/dbus-1/system.d/io.github.uunicorn.Fprint.conf";
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE busconfig PUBLIC
       "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
       "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
      <busconfig>
        <policy user="root">
          <allow own="io.github.uunicorn.Fprint"/>
        </policy>
        <policy user="root">
          <allow send_destination="io.github.uunicorn.Fprint"
                 send_interface="io.github.uunicorn.Fprint.Device"/>
        </policy>
      </busconfig>
    '';
  };
in
{
  options.my.hardware.sil6250.enable =
    lib.mkEnableOption "the sil6250 fingerprint stack (kernel module + sil6250d daemon + open-fprintd)";

  config = lib.mkIf config.my.hardware.sil6250.enable {
    boot.extraModulePackages = [ sil6250 ];
    boot.kernelModules = [ "sil6250" ];

    services.udev.extraRules = ''
      SUBSYSTEM=="misc", KERNEL=="sil6250", TAG+="uaccess", MODE="0660", GROUP="users"
    '';

    # D-Bus policy for the two daemons. open-fprintd ships its own
    # net.reactivated.Fprint.conf (lets root own the manager name and default
    # callers reach it); sil6250d's conf is written out above.
    services.dbus.packages = [
      sil6250dDBusConf
      openFprintd
    ];

    # open-fprintd replaces fprintd as the net.reactivated.Fprint manager; the
    # two cannot run side by side (well-known name clash on the system bus).
    services.fprintd.enable = lib.mkForce false;

    # Ships open-fprintd's suspend/resume units (they call the Manager, which
    # forwards Suspend/Resume to sil6250d).
    systemd.packages = [ openFprintd ];

    systemd.services.open-fprintd = {
      description = "Open FPrint Daemon (sil6250 manager)";
      wantedBy = [ "multi-user.target" ];
      # The packaged unit already sets Type=dbus, BusName and ExecStart; only
      # add restart hardening. Do NOT redeclare ExecStart here: the duplicate
      # makes systemd reject the unit (multiple ExecStart only allowed for
      # Type=oneshot).
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "3";
      };
    };

    systemd.services.sil6250d = {
      description = "Silead SIL6250 fingerprint daemon (open-fprintd backend)";
      after = [
        "dbus.service"
        "open-fprintd.service"
      ];
      wants = [ "open-fprintd.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "io.github.uunicorn.Fprint";
        ExecStart = "${sil6250d}/bin/sil6250d";
        Environment = "SIL6250_DEV=/dev/sil6250";
        User = "root";
        Group = "root";
        # /dev/sil6250 is a misc char device not on fprintd's default
        # DeviceAllow list.
        DeviceAllow = "/dev/sil6250 rw";
        Restart = "on-failure";
        RestartSec = "3";
      };
    };

    # fprintd-enroll / fprintd-list CLI clients talk to net.reactivated.Fprint
    # (now served by open-fprintd); the fprintd service itself stays off.
    environment.systemPackages = [ pkgs.fprintd ];

    # Elsewhere in NixOS, fprintAuth defaults to services.fprintd.enable; since
    # this module forces that off (open-fprintd manages the net.reactivated.Fprint
    # well-known name instead), PAM would silently never offer a fingerprint
    # option. Opt in explicitly per service so pam_fprintd.so authenticates
    # through open-fprintd at login, the KDE screen locker, polkit prompts and
    # sudo. Note services.fprintd.package still points at stock fprintd, which
    # ships the pam module we load here.
    #
    # The KDE screen locker must NOT get fprintAuth on its `kde` service (it can
    # block password login, see NixOS/nixpkgs#239770); nixpkgs creates a separate
    # `kde-fingerprint` service instead, which we replicate here.
    security.pam.services = {
        # sddm.fprintAuth = true;
        # login.fprintAuth = true
        sudo.fprintAuth = true;
        kde-fingerprint.fprintAuth = true;
        polkit-1.fprintAuth = true;
    };
  };
}
