{ ... }:

{
  users.users.hazie = {
    isNormalUser = true;
    description = "Hazie";
    extraGroups = [ "wheel" ];

    # Public keys are intentionally kept in a separate, non-secret file.
    openssh.authorizedKeys.keyFiles = [
      ./authorized_keys
    ];
  };

  my.server = {
    ssh = {
      enable = true;
      allowedUsers = [ "hazie" ];
    };
    fail2ban.enable = true;
  };
}
