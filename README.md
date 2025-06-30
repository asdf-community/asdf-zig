<div align="center">

# asdf-zig [![Build](https://github.com/asdf-community/asdf-zig/actions/workflows/build.yml/badge.svg)](https://github.com/asdf-community/asdf-zig/actions/workflows/build.yml)

[Zig](http://ziglang.org/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Dependencies

- `bash`, `python3`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- asdf 0.16+

# Install

After installing [asdf](https://asdf-vm.com/guide/getting-started.html), install the plugin by running:

```shell
asdf plugin add zig https://github.com/asdf-community/asdf-zig.git
```

Then use `asdf-zig` to install zig:

```shell
# Show all installable versions
asdf list all zig

# Install specific version
asdf install zig latest

# Set a version globally (on your ~/.tool-versions file)
asdf set --home zig latest

# Now asdf-zig commands are available
zig version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# License

See [LICENSE](LICENSE)
