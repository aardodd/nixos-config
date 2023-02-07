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
              content = {
                type = "btrfs";
                extraArgs = "--label root -f"; # Override existing partition
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    postCreateHook = ''
                      mkdir -p $MNTPOINT
                      mount -t btrfs /dev/disk/by-label/root $MNTPOINT -o subvol=/
                      btrfs subvolume snapshot -r $MNTPOINT/root $MNTPOINT/root-blank
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
