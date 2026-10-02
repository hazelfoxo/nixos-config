{
  config,
  lib,
  pkgs,
  ...
}:

# University profile configuration for NixOS hosts

# Campus VPN, the university GitLab over SSH, and Teams for Linux.

let
  cfg = config.my.profiles.university;
in
{
  options.my.profiles.university = {
    enable = lib.mkEnableOption "the university profile (VPN, GitLab, Teams)";

    vpn.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "campus VPN";
    };

    git.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "university GitLab over SSH";
    };

    teams.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Teams for Linux";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.vpn.enable {
      my.openvpn = {
        enable = true;
        profiles.school = {
          connectionName = "School VPN";
          usernameSecret = "school-openvpn-username";
          passwordSecret = "school-openvpn-password";
          remote = "vpn.chester.ac.uk";
          port = 1195;
          protocol = "udp";
          configFile = ../../assets/openvpn/school.ovpn;
          neverDefault = true;
        };
      };
    })

    (lib.mkIf cfg.git.enable {
      my.ssh.enable = true;

      my.ssh.hosts."git.chester.network" = {
        address = "git.chester.network";
        user = "git";
        sopsKey = "school-gitlab-ssh-private-key";
        knownHostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH01CaONW6JX9VW6m7DpCJvNkBM4ndbAWJu+V4QduVex";
      };
    })

    (lib.mkIf cfg.teams.enable {
      environment.systemPackages = with pkgs; [
        teams-for-linux
      ];
    })
  ];
}
