{
  config,
  lib,
  pkgs,
  ...
}:

# Kernel selection for NixOS hosts

{
  options.my.boot.kernel = lib.mkOption {
    type = lib.types.enum [
      "default"
      "latest"
    ];
    default = "default";
    description = ''
      Kernel series to run on this host.

      - "default" tracks nixpkgs' default kernel, the most widely
        tested option.
      - "latest" tracks the newest mainline release nixpkgs carries. It
        runs ahead of "default", so expect less testing.

      Selecting via `boot.kernelPackages` keeps the matching NVIDIA and
      out-of-tree module packages in step, since those are derived from
      the chosen kernel package set.
    '';
  };

  config = lib.mkIf (config.my.boot.kernel == "latest") {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
