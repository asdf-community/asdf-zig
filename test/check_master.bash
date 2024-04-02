#!/usr/bin/env bash

version="master"
status="$1"

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
json=$(cat mock.json)

source "$(dirname "$0")/../lib/check_and_update_master.bash"

if [[ "$status" == "rollback" ]]; then
    rollback_master "0.12.0-dev.3508+a6ed3e6d2"
else
    check_master "$version" "$platform" "$architecture" "$json"
fi

