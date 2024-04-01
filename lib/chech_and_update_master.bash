#!/usr/bin/env bash

source "$(dirname "$0")/../lib/json.bash"

fail() {
  echo -e "\e[31mFail:\e[m $*"
  exit 1
}

chech_master() {
    local version="$1"
    local platform="$2"
    local architecture="$3"
    local json="$4"

    if [[ "$version" == "master" ]]; then
        local tarball_path="$(find ~/.asdf/installs/zig/master -name "*.tar.xz")"

        if [[ -z "$tarball_path" ]]; then
            fail "Tarball not found in ~/.asdf/installs/zig/master"
        fi

        local computed_shasum="$(shasum -a 256 "$tarball_path" | awk '{print $1}')"
        echo "Computed shasum: $computed_shasum"
        local expected_shasum=$(json_parse "$json" | grep "\[\"$version\",\"${architecture}-${platform}\",\"shasum\"\]" | awk '{print $2}' | tr -d '"')
        echo "Expected shasum: $expected_shasum"

        if [[ "$computed_shasum" == "$expected_shasum" ]]; then
            version=$(json_parse "$json" | grep "\[\"master\",\"version\"\]" | awk '{print $2}' | tr -d '"')
            echo "Same match, new version: $version"
            
            update_master "$version"
        fi
    fi
}

update_master() {
    local version="$1"
    
    mv ~/.asdf/installs/zig/master ~/.asdf/installs/zig/"$version"
    sed -i '' "1a\\
    # asdf-plugin: zig ${version}
    "  ~/.asdf/shims/zig
}

rollback_master() {
    local version="$1"
    local new_version="master"

    mv ~/.asdf/installs/zig/"$version" ~/.asdf/installs/zig/master
    sed -i '' "1a\\
    # asdf-plugin: zig ${new_version}
    "  ~/.asdf/shims/zig
}