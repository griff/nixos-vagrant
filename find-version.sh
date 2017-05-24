
export NIXOS_VERSION="17.03.$(curl https://nixos.org/nixos/download.html | sed  -n -E "s/.*<strong>17.03.(.+)<.strong>.*/\1/p")"
export NIXOS_CHECKSUM="$(curl -L "https://d3g5gsiof5omrk.cloudfront.net/nixos/17.03/nixos-${NIXOS_VERSION}/nixos-minimal-${NIXOS_VERSION}-x86_64-linux.iso.sha256")"
echo "Nixos: ${NIXOS_VERSION} ${NIXOS_CHECKSUM}"

sed -i '' -e "s#\"nixos_version\": \".*\",#\"nixos_version\": \"${NIXOS_VERSION}\",#" nixos.json
sed -i '' -e "s#\"nixos_checksum\": \".*\",#\"nixos_checksum\": \"${NIXOS_CHECKSUM}\",#" nixos.json