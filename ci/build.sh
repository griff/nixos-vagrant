#!/bin/bash
function join_by {
    local d=$1; shift; local f=$1; shift; printf %s "$f" "${@/#/$d}";
}

if ! command -v packer > /dev/null ; then
  brew install packer
fi

if command -v VBoxManage > /dev/null ; then
  builders=(virtualbox-iso $builders)
fi
if command -v vmrun > /dev/null ; then
  builders=(vmware-iso $builders)
fi

packer version
if [ -f ".env" ]; then
  . .env
fi
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
echo "nixos-$VERSION-var.json" 
cat nixos-$VERSION-var.json
export PACKER_KEY_INTERVAL=10ms
packer build \
    $extra_args \
    --only=$(join_by , "${builders[@]}") \
    -var-file=nixos-$VERSION-var.json \
    "$FILE"
