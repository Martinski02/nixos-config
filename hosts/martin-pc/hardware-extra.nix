{ ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };
}
