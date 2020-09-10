#!/bin/bash
if ! command -v packer > /dev/null ; then
  brew install packer
fi
packer version
if [ "$CLOUD_TOKEN" == "" ]; then
    echo "Build will skip vagrant-cloud deploy."
    export CLOUD_TOKEN="junk"
    cat nixos.json | jq 'del(.["post-processors"][0] | .[1])' > nixos-build.json
    export FILE=nixos-build.json
else
    export FILE=nixos.json
fi
if [ -z "$1" ]; then
  export VERSION="stable"
else
  export VERSION="$1"
fi
export PACKER_KEY_INTERVAL=10ms
packer build \
    $extra_args \
    -var-file=nixos-$VERSION-var.json \
    "$FILE"