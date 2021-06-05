#!/bin/bash

./find-version.sh write 20.03 > nixos-20.03-var.json
./find-version.sh write 20.09 > nixos-20.09-var.json
./find-version.sh write 21.05 > nixos-21.05-var.json
./find-version.sh write stable > nixos-stable-var.json
