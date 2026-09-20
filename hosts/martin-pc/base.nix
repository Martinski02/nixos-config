{ ... }:

{
  system.stateVersion = "26.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
    algorithm = "zstd";
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 40960;
      priority = 10;
    }
  ];

  boot.resumeDevice = "/dev/mapper/cryptroot";

  boot.kernelParams = [
    "resume_offset=145000448"
  ];

  environment.etc."crypttab".text = ''
    cryptdata UUID=053529f8-77c7-4005-8660-e4c281d2522b /root/.keys/cryptdata.key luks
    cryptbackup UUID=881e21ff-c13a-4799-8a58-a21178ab8b4b /root/.keys/cryptbackup.key luks,nofail
  '';

  fileSystems."/mnt/data" = {
    device = "/dev/mapper/cryptdata";
    fsType = "ext4";
  };

  fileSystems."/mnt/backup" = {
    device = "/dev/mapper/cryptbackup";
    fsType = "ext4";
    options = [ "nofail" ];
  };
}
