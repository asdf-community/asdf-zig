#!/usr/bin/env bash

version="master"

source "$(dirname "$0")/../lib/json.bash"
# json=$(curl --fail --progress-bar  --location https://ziglang.org/download/index.json)
json=$(cat mock.json)

case "$(uname -m)" in
    aarch64* | arm64) architecture="aarch64" ;;
    armv7*) architecture="armv7a" ;;
    i686*) architecture="i386" ;;
    riscv64*) architecture="riscv64" ;;
    x86_64*) architecture="x86_64" ;;
    *) fail "Unsupported architecture" ;;
esac

case "$OSTYPE" in
    darwin*) platform="macos" ;;
    freebsd*) platform="freebsd" ;;
    linux*) platform="linux" ;;
    *) fail "Unsupported platform" ;;
esac

if [[ "$version" == "master" ]]; then
    version=$(json_parse "$json" | grep "\[\"master\",\"version\"\]" | awk '{print $2}' | tr -d '"')
    tarball=$(json_parse "$json" | grep "\[\"master\",\"src\",\"tarball\"\]" | awk '{print $2}' | tr -d '"')
    shasum=$(json_parse "$json" | grep "\[\"master\",\"src\",\"shasum\"\]" | awk '{print $2}' | tr -d '"')
else
    tarball=$(json_parse "$json" | grep "\[\"$version\",$arch_platform_path,$tarball_key\]" | awk '{print $2}' | tr -d '"')
    shasum=$(json_parse "$json" | grep "\[\"$version\",$arch_platform_path,$shasum_key\]" | awk '{print $2}' | tr -d '"')
fi

echo "shasum: $shasum, $version, $tarball, $platform, $architecture"
