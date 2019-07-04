#!/bin/sh
set -o errexit
set -x

sgdisk -a1 -n2:34:2047  -t2:EF02 /dev/sda
sgdisk     -n1:0:0      -t1:BF01 /dev/sda

mkfs.ext4 -L nixos /dev/sda1
while [[ ! -b /dev/disk/by-label/nixos ]]; do
  sleep 1
  ls -la /dev/disk/by-label/
done
mount /dev/disk/by-label/nixos /mnt
lsblk
du -sch /nix/.rw-store/*

mkdir -p /mnt/etc/nixos
