#!/bin/sh
set -o errexit
set -x

mkdir -p /mnt/etc/nixos
chown -R root:root /mnt/etc/nixos
nixos-generate-config --root /mnt
cat /mnt/etc/nixos/hardware-configuration.nix
cd /mnt/etc/nixos
ln -s ${PACKER_BUILDER_TYPE}.nix provider.nix
nixos-install

mkdir -p /mnt/root/.ssh
cp /root/.ssh/authorized_keys /mnt/root/.ssh/authorized_keys
chmod 600 /mnt/root/.ssh/authorized_keys
