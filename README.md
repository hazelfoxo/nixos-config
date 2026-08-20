# nixos-config
A basic NixOS config for own personal use built for KDE Plasma, with all apps and tools I use regularly. 

It's a nix flake based setup that I've tailored for my own workflow. It contains a stock KDE install with some optional quality of life applications and tweaks that I use. 

## Installation
1. Create the configuration directory
```
$ mkdir -p ~/nixos-config
```

3. Move into it
```
$ cd ~/nixos-config
```

4. Clone the repository into the current directory
```
$ git clone https://github.com/hazelfoxo/nixos-config.git .
```

6. Replace /etc/nixos with a symlink to the configuration
```
$ sudo rm -rf /etc/nixos
$ sudo ln -s ~/nixos-config /etc/nixos
```

5. Build and activate the configuration
```
$ sudo nixos-rebuild switch --flake /etc/nixos#desktop
```

## Apps
- Discord
- Telegram
- Spotify with Adblocking
- GPU Screenrecorder

## Hardware
- Bluetooth
- Optional Nvidia Module

## Structure
nixos-config/  
├── home/       # Home Manager and user configuration  
├── hosts/      # Host-specific NixOS configurations  
├── modules/    # NixOS modules  
├── overlays/   # Nixpkgs overlays and package modifications  
├── packages/   # Custom packages and package definitions  
└── flake.nix   # Flake entry point and system configuration  

## Hosts
- Desktop host with NVIDIA driver support

## Aliased Commands
### Nix Commands
- nix-switch - builds configuration and immediately activates it
- nix-upgrade - updates flake.lock and runs nix-switch aftewards
- nix-clean - clears old generations older than 14 days
- nix-clean-all - clears all old generations
