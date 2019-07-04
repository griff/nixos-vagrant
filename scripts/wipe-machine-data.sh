#!/bin/sh
set -x

# Remove SSH host key to generate new one on first boot
rm -rf /etc/ssh/ssh_host_*
# Remove Machine id to generate new one on first boot
rm /etc/machine-id

# Cleanup any previous generations and delete old packages that can be
# pruned.
for x in $(seq 0 2) ; do
  nix-env --delete-generations old
  nix-collect-garbage -d
done

# Zero out the disk (for better compression)
dd if=/dev/zero of=/EMPTY bs=1M
rm -rf /EMPTY
