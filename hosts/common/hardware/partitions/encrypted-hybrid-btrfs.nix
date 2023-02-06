{ disks ? [ "/dev/sda" ], ... }:
{
  disk = {
    main = {
      type = "disk";
      device = builtins.elemAt disks 0;
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "boot";
            type = "partition";
            start = "0";
            end = "1M";
            flags = [ "bios_grub" ];
          }
          {
            name = "ESP";
            type = "partition";
            start = "1M";
            end = "512M";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "root";
            type = "partition";
            start = "512M";
            end = "100%";
            content = {
              name = "crypted";
              type = "luks";
              keyFile = "/tmp/disk.key";
              content = {
                type = "btrfs";
                extraArgs = "-f"; # Override existing partition
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    postCreateHook = ''
                      mkdir -p $MNTPOINT
                      mount /dev/mapper/crypted $MNTPOINT -o subvol=/root
                      btrfs subvolume snapshot -r $MNTPOINT $MNTPOINT/root-blank
                      umount $MNTPOINT
                      rm -rf $MNTPOINT
                    '';
                  };
                  "/home" = {
                    mountOptions = [ "compress=zstd" ];
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
            };
          }
        ];
      };
    };
  };
}