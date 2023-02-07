#!/usr/bin/env bash
# fs-diff.sh
# should be used with the encrypted-hybrid-btrfs partitioning scheme.

# mount
mkdir --parents /mnt
mount -o subvol=/ /dev/mapper/crypted /mnt

# list new directories
set -euo pipefail

OLD_TRANSID=$(btrfs subvolume find-new /mnt/root-blank 9999999)
OLD_TRANSID=${OLD_TRANSID#transid marker was }

btrfs subvolume find-new "/mnt/root" "$OLD_TRANSID" |
sed '$d' |
cut -f17- -d' ' |
sort |
uniq |
while read path; do
	path="/$path"
	if [ -L "$path" ]; then
		: # the path is a symbolic link, so probably handled by NixOS already.
	elif [ -d "$path" ]; then
		: # the path is a directory, ignore.
	else
		echo "$path"
	fi
done

# cleanup
umount /mnt
rm -rf /mnt

