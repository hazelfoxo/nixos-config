{ ... }:

# Enable and configure the Starship prompt for the shell

{
  programs.starship = {
    enable = true;
    # Configure starship for fish
    enableFishIntegration = true;
    # Copy starship config files from repo
    # Config is preset from startship website
    settings = builtins.fromTOML (builtins.readFile ../../files/starship/jetpack.toml);
  };
}
