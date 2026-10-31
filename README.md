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

# Mirrors

Zig downloads use the community mirror list when available. The list is stored in
`lib/commands/community-mirrors.txt` and is automatically downloaded when missing
or older than 30 days. If all mirrors fail, the download falls back to the official
Zig URL.

You can inspect or manually update the mirror list with:

```shell
# Show the current mirror list
asdf cmd zig mirror

# Download the latest mirror list
asdf cmd zig mirror-update
```

Configure the mirror list refresh interval with `ASDF_ZIG_MIRROR_MAX_AGE` (in
days; default: `30`):

```shell
ASDF_ZIG_MIRROR_MAX_AGE=7 asdf install zig latest
```

# License

[Apache License 2.0](LICENSE)
