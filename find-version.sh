
version() {
  local major="$1"
  export NIXOS_VERSION="${major}.$(curl -L https://nixos.org/channels/nixos-${major} | sed  -n -E "s/.*-x86_64-linux.iso'>nixos-minimal-${major}.([^<]+)-x86_64-linux.iso<.a>.*/\1/p")"
  export NIXOS_URL="https://d3g5gsiof5omrk.cloudfront.net/nixos/${major}/nixos-${NIXOS_VERSION}/nixos-minimal-${NIXOS_VERSION}-x86_64-linux.iso"
  export NIXOS_CHECKSUM_URL="${NIXOS_URL}.sha256"
  export NIXOS_CHECKSUM="$(curl "$NIXOS_CHECKSUM_URL" | sed -nE 's/^([^ ]+).*/\1/p')"
  export VAGRANT_VERSION="$(echo $NIXOS_VERSION | sed -n -E 's/^([0-9]+)\.([0-9]+)\.([0-9]+).*$/\1\2.\3/p')"
}

print_version() {
  version "$1"
  echo "Nixos: ${NIXOS_VERSION}"
  echo "Vagrant: ${VAGRANT_VERSION}"
}

write_vars() {
  version "$1"
  echo "{"
  echo "  \"nixos_release\": \"$2\","
  echo "  \"nixos_url\": \"$NIXOS_URL\","
  echo "  \"nixos_checksum_url\": \"$NIXOS_CHECKSUM_URL\","
  echo "  \"nixos_checksum\": \"$NIXOS_CHECKSUM\","
  echo "  \"nixos_version\": \"$NIXOS_VERSION\","
  echo "  \"vagrant_version\": \"$VAGRANT_VERSION\""
  echo "}"
}

if [ "$1" == "write" ] && [ -n "$2" ]; then
  actual="$2"
  if [ "$2" == "stable" ]; then
    actual="$(curl -L https://nixos.org/download.html | sed -n -E 's/.*<strong>([0-9]+)\.([0-9]+)<.*/\1.\2/p')"
  fi
  write_vars "$actual" "$2"
fi
