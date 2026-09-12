{ ... }:

# Audio configuration for NixOS hosts

{
  # Disales PulseAudio Service
  services.pulseaudio.enable = false;

  # Enable Realtime Audio
  security.rtkit.enable = true;
  # Enables PipeWire service
  services.pipewire = {
    enable = true;

    # Enable ALSA Service
    alsa.enable = true;
    alsa.support32Bit = true;

    # Enable PulseAudio > PipeWire Compatability Layer
    pulse.enable = true;

    # jack.enable = true;
  };
}
