# nixos-config
A basic NixOS config for own personal use built for KDE Plasma, with all apps and tools I use regularly. 

It's a nix flake based setup that I've tailored for my own workflow. It contains a stock KDE Plasma install with some optional KDE apps.

<img width="3440" height="1440" alt="Screenshot_20260905_013414" src="https://github.com/user-attachments/assets/6bb144f2-0c53-4d6c-83e4-c381a65aac2e" />

## Installation
1. Clone the repo and move it into a directory that isn't `~/nixos-config`.
2. Copy your personal key into the repo and run `setup.sh`
3. Chose a configuration and let the system build itself.
4. Enjoy your build system.

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
├── modules/    # Reusable NixOS modules  
│   ├── core/       # Base OS, Nix, users, secrets, and boot settings  
│   ├── hardware/   # Shared hardware and GPU-driver modules  
│   ├── networking/ # Low-level network and VPN module definitions  
│   ├── profiles/   # Self-contained, enable-able profiles (desktop, gaming, ...)
│   └── services/   # Server services (SSH server, fail2ban)
│   └── users/      # User accounts and Home Manager wiring  
├── secrets/    # Stores secrets for SSH and Wireguard  
└── flake.nix   # Flake entry point and system configuration  
└── setup.sh    # Bootstrap for installing repo  

## Hosts
- Desktop host with NVIDIA driver support
- Laptop host with Intel GPU support
- Minimal headless server template; replace its generic hardware template and
  add services before deploying it. Paste administrator public keys into
  `hosts/server/authorized_keys`.

## Aliased Commands
### Nix Commands
- nix-switch - builds configuration and immediately activates it
- nix-upgrade - updates flake.lock and runs nix-switch aftewards
- nix-clean - clears old generations older than 14 days
- nix-clean-all - clears all old generations
