{ config, lib, pkgs, ... }:

let

cfg = config.my.ssh;

in

{

options.my.ssh = {

enable = lib.mkEnableOption "SSH client";

privateKeySecret = lib.mkOption {

  type = lib.types.str;

  default = "ssh_remote_server_private_key";

  description = "SOPS secret containing the SSH private key.";

};

name = lib.mkOption {

  type = lib.types.str;

  description = "Local SSH alias used to connect to the remote server.";

};

address = lib.mkOption {

  type = lib.types.str;

  description = "Hostname or IP address of the remote server.";

};

port = lib.mkOption {

  type = lib.types.port;

  default = 22;

  description = "SSH port of the remote server.";

};

user = lib.mkOption {

  type = lib.types.str;

  description = "SSH username on the remote server.";

};

knownHostKey = lib.mkOption {

  type = lib.types.str;

  description = "SSH host key for the remote server.";

};

};

config = lib.mkIf cfg.enable {

environment.systemPackages = [

  pkgs.openssh

];

sops.secrets.${cfg.privateKeySecret} = {

  owner = "hazie";

  group = "users";

  mode = "0400";

};

programs.ssh.extraConfig = ''

  Host ${cfg.name}

    HostName ${cfg.address}

    Port ${toString cfg.port}

    User ${cfg.user}

    IdentityFile ${config.sops.secrets.${cfg.privateKeySecret}.path}

    IdentitiesOnly yes

'';

programs.ssh.knownHosts.${cfg.name} = {

  hostNames = [

    cfg.address

    "[${cfg.address}]:${toString cfg.port}"

  ];

  publicKey = cfg.knownHostKey;

};

};

}