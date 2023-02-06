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
              type = "zfs";
              pool = "rpool";
            };
          }
        ];
      };
    };
  };
  zpool = {
    "rpool" = {
      type = "zpool";
      mode = "";
      options = {
        ashift = "12";
        autotrim = "on";
      };
      postCreateHook = ''zfs set keylocation="prompt" $name'';
      rootFsOptions = {
        compression = "zstd";
        encryption = "on";

        # insert via secrets
        keylocation = "file:///tmp/disk.key";
        keyformat = "passphrase";

        acltype = "posixacl";
        mountpoint = "none";
        canmount = "off";
        xattr = "sa";
        dnodesize = "auto";
        normalization = "formD";
        relatime = "on";
      };
      datasets = let
        unmountable = {
          zfs_type = "filesystem";
          mountpoint = null;
          options.canmount = "off";
        };
        filesystem = mountpoint: {
          zfs_type = "filesystem";
          inherit mountpoint;
          # options."com.sun:auto-snapshot" = "true";
        };
      in {
        "local" = unmountable;
        "safe" = unmountable;
        "local/root" = filesystem "/" // {
          postCreateHook = "zfs snapshot rpool/local/root@blank";
          options.mountpoint = "legacy";
        };
        "local/nix" = filesystem "/nix" // { options.mountpoint = "legacy"; };
        "safe/home" = filesystem "/home";
        "safe/persist" = filesystem "/persist";
      };
    };
  };
}