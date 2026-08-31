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

  services.openssh = {
    enable = true;
    openFirewall = false;
    ports = [ 2222 ];

    settings = {
      AllowUsers = [ "hazie" ];
      PermitRootLogin = "no";
      MaxAuthTries = 3;
      PubkeyAuthentication = true;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
      PrintMotd = false;
      ClientAliveInterval = 100;
      ClientAliveCountMax = 3;
    };
  };
}
