#!/bin/bash
if ! command -v packer ; then
  brew install packer
fi
if [ "$CLOUD_TOKEN" == "" ]; then
    export CLOUD_TOKEN="junk"
    cat nixos.json | jq 'del(.["post-processors"][0] | .[1])' > nixos-build.json
    export FILE=nixos-build.json
else
    export FILE=nixos.json
fi
export PACKER_KEY_INTERVAL=10ms
packer build \
    $extra_args \
    --only=virtualbox-iso \
    -var-file=nixos-stable-var.json \
    "$FILE"