# nixos-config
A basic NixOS config for own personal use built for KDE Plasma, with all apps and tools I use regularly. 

It's a nix flake based setup that I've tailored for my own workflow. It contains a stock KDE Plasma install with some optional KDE apps.

## Installation
1. Download `setup.sh` script and execute it.   
2. Follow the installation steps within the script.
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
├── secrets/    # Stores secrets for SSH and Wireguard
└── flake.nix   # Flake entry point and system configuration  
└── setup.sh    # Bootstrap for installing repo

## Hosts
- Desktop host with NVIDIA driver support
- Laptop host with Intel GPU support

## Aliased Commands
### Nix Commands
- nix-switch - builds configuration and immediately activates it
- nix-upgrade - updates flake.lock and runs nix-switch aftewards
- nix-clean - clears old generations older than 14 days
- nix-clean-all - clears all old generations
