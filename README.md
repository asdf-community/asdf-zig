<div align="center">

# asdf-zig [![Build](https://github.com/asdf-community/asdf-zig/actions/workflows/build.yml/badge.svg)](https://github.com/asdf-community/asdf-zig/actions/workflows/build.yml)

[Zig](http://ziglang.org/) plugin for the [asdf version manager](https://asdf-vm.com).

As a bonus, this plugin supports installing zls as well, so zls and zig version can match exactly.

</div>

# Dependencies

- `bash`, `python3`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- asdf 0.16+

# Install

After installing [asdf](https://asdf-vm.com/guide/getting-started.html), install the plugin by running:

```shell
asdf plugin add zig https://github.com/asdf-community/asdf-zig.git
```

or update an existing installation:

```shell
asdf plugin update zig
```

Then use `asdf-zig` to manage zig:

```shell
# Show all installable versions
asdf list all zig

# Install specific version

asdf install zig 0.16.0

# or install latest tagged version with
asdf install zig latest

# Set a version globally (on your ~/.tool-versions file)
asdf set --home zig latest

# Now zig commands are available
zig version

# You can also check the ZLS version.
# It is designed to be highly compatible with the specific Zig version you installed.
zls version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Custom Versions

This plugin supports installing custom zig versions that are not in the official release index.

## Why?

The official `asdf-zig` can only support versions listed at `https://ziglang.org/download/index.json`. But zig evolves fast, and sometimes you need to stick with a specific dev version like `0.12.0-dev.2139+e025ad7b4`.

## How to use custom versions

1. Create the custom versions directory and file:

```bash
mkdir -p ~/.asdf/custom/zig
echo '{"0.12.0-dev.2139+e025ad7b4": {}, "0.12.0-dev.1828+225fe6ddb": {}}' > ~/.asdf/custom/zig/versions.json
```

2. Your custom versions will now appear in `asdf list all zig` and can be installed with `asdf install zig <version>`.

## Installing master version

You can also install the current master version of zig:

```bash
asdf list all zig  # Shows master_<version> at the end
asdf install zig master_<version>
```

The master version is prefixed with `master_` to distinguish it from release versions.

# License

[Apache License 2.0](LICENSE)
