# nixos-config
A basic NixOS config for own personal use built for KDE Plasma, with all apps and tools I use regularly. 

It's a nix flake based setup that I've tailored for my own workflow. It contains a stock KDE Plasma install with some optional KDE apps.

<img width="3440" height="1440" alt="Screenshot_20260905_013414" src="https://github.com/user-attachments/assets/6bb144f2-0c53-4d6c-83e4-c381a65aac2e" />

## Installation
1. Boot into the install media - the full and minimal iso work.
2. Connect to the internet and clone the repo onto the live environment.
3. Copy your personal key into the repo and run `setup.sh`
4. Choose a configuration and watch as the system builds itself.
6. Enjoy your built system.

## Hosts
- `desktop` host with NVIDIA driver support
- `laptop` host with Intel GPU support
- `server` minimal host (WIP)

## Packages

<details>
<summary><b>System</b></summary>

- git
- htop
- btop
- fastfetch
- usbutils
- pciutils
- sops

</details>

<details>
<summary><b>Home</b></summary>

### Personal
- Discord
- Telegram
- Spotify (SpotX, ad-free)
- Feishin (music player)
- LibreOffice
- Thunderbird

### Tools
- HandBrake
- yt-dlp
- mprisence (Discord rich presence)
- nixctl (config manager)
- VS Code
- Kitty

### Browsers
- Google Chrome
- Firefox

### System Tools
- Fish
- Starship
- Fastfetch
- Git
- SSH agent

</details>

## Profiles

<details>
<summary><b>Desktop (KDE) (Configurable)</b></summary>

- KDE Plasma 6
- Kate
- KCalc
- Haruna
- KPartitionManager
- SDDM
- GPU Screen Recorder

</details>

<details>
<summary><b>Gaming (Configurable)</b></summary>

- Steam
- Prism Launcher (Minecraft)

</details>

<details>
<summary><b>Creative (Configurable)</b></summary>

- Krita
- MyPaint
- Inkscape
- GIMP
- Darktable
- RawTherapee
- Kdenlive
- ffmpeg
- HandBrake
- Blender
- FreeCAD

</details>

<details>
<summary><b>Music (Configurable)</b></summary>

- Feishin
- Picard
- Kid3

</details>

<details>
<summary><b>Dev (Configurable)</b></summary>

- android-tools
- opencode

</details>

<details>
<summary><b>University</b></summary>

- Teams for Linux

</details>

<details>
<summary><b>Homeserver</b></summary>

- Tailscale
- sshfs

</details>

<details>
<summary><b>VPN</b></summary>

- Proton VPN
- Tailscale

</details>

## Hardware
- Bluetooth
- Optional Nvidia Module

## Structure
nixos-config/  
├── assets/     # Configuration Assets  
├── home/       # Home Manager and user configuration  
├── hosts/      # Host-specific NixOS configurations  
├── modules/    # Reusable NixOS modules  
│   ├── core/        # Base OS, Nix, secrets, and boot settings  
│   ├── hardware/    # Shared hardware and GPU-driver modules  
│   ├── networking/  # Connectivity modules and their config (Wi-Fi, SSH, VPN)  
│   ├── profiles/    # Self-contained, enable-able profiles (desktop, gaming, ...)  
│   ├── server/      # Server-only options and services (SSH server, firewall, ...)  
│   └── users/       # User accounts and Home Manager wiring  
├── secrets/    # Stores secrets for SSH and Wi-Fi  
│   └── hosts/       # Encypted secrets for hosts  
│   └── device-keys/ # Encrypted per device decryption keys  
│   └── shared.yaml  # Shared encrypted secrets between all hosts    
└── flake.nix   # Flake entry point and system configuration  
└── setup.sh    # Bootstrap for installing repo  

### Configuration layout

- `my.profiles.*` - opt-in software bundles, enabled from a host's `default.nix`
- `my.wifi` / `my.ssh` / `my.wireguard` / `my.openvpn` - one switch per subsystem, with its connection/host data
- `my.server.*` - server-only options, available on hosts that import `modules/server`
- `my.host.*` - per-host metadata injected by `flake.nix`
- Flake inputs (SpotX, VS Code marketplace, plasma-manager, sil6250) are passed to modules as arguments, not options

Shared data is imported, not gated behind a second option: the workstation hosts
import `modules/networking/shared-connections.nix` (home Wi-Fi networks) and
`modules/networking/github.nix` (GitHub SSH key and host key) alongside the
matching `my.wifi` / `my.ssh` settings.

## `nixctl`
This is a unified tool for managing the NixOS configuration.

### Usage
```
nixctl <command>
```

### Commands
- `nixctl pull` - pull latest configuration repo commits and switch system
- `nixctl pull --pull-only` - pull without switching system
- `nixctl switch` - rebuild system from flake and switch to it
- `nixctl upgrade` - updates all packages and pushes the new `flake.lock`
- `nixctl push [msg]` - stage all changes, commit them and push (opens an editor if no message is given)
- `nixctl clean` - garbage-collect generations older than 14 days
- `nixctl clean-all` - garbage-collect all old generations
- `nixctl shell <pkg…>` - open a `nix-shell` with the given packages
- `nixctl help` - show usage

### Environment
- `NIXOS_CONFIG` - path to the configuration repo
- `NIXOS_HOST` - flake attribute to build
