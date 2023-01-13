{ disks ? [ "/dev/sda" ], ... }: {
  disk = {
    one = {
      device = builtins.elemAt disks 0;
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "bios-boot";
            type = "partition";
            start = "0";
            end = "8M";
            part-type = "primary";
            flags = [ "bios_grub" ];
          }
          {
            name = "uefi-boot";
            type = "partition";
            start = "8M";
            end = "520M";
            part-type = "primary";
            flags = [ "boot" "esp" ];
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "root";
            type = "partition";
            start = "520M";
            end = "100%";
            part-type = "primary";
            content = {
              type = "btrfs";
              extraArgs = "-f"; # Override existing partition
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/home" = {
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/nix" = {
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/persist" = {
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/log" = {
                  mountOptions = [ "compress=zstd" "noatime" ];
                  mountpoint = "/var/log";
                };
              };
            };
          }
        ];
      };
    };
  };
}