#!/bin/sh
set -o errexit

lsblk
if [[ -f "/mnt/etc/nixos/hardware-configuration.nix" ]]; then
  cat /mnt/etc/nixos/hardware-configuration.nix
else
  cat /etc/nixos/hardware-configuration.nix
fi
