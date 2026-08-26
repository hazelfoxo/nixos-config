{ ... }:

{
    programs.starship = {
    # Enable startship service
        enable = true;
        # Configure starship for fish
        enableFishIntegration = true;
        settings = builtins.fromTOML (
        builtins.readFile ../files/starship/jetpack.toml
        );
    };
}
