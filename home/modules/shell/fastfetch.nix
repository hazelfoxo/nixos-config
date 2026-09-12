{ ... }:

# Enable fastfetch and configure its settings

{
  programs.fastfetch = {
    enable = true;
  };

  # Copy fastfetch config files from repo
  home.file.".config/fastfetch".source = ../../files/fastfetch;
}
