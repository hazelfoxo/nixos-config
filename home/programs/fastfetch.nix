{ ... }:

{
    programs.fastfetch = {
        # Enable startship service
        enable = true;
    };
    
    # Copy fastfetch config files from repo
    home.file.".config/fastfetch".source = ../files/fastfetch;
}
