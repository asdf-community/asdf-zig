# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an [asdf](https://asdf-vm.com) plugin for managing [Zig](https://ziglang.org/) installations. It also supports installing [ZLS](https://github.com/zigtools/zls) (Zig Language Server) alongside Zig for IDE support.

## Code Architecture

The plugin follows the asdf plugin convention with scripts in `bin/` and shared logic in `lib/`:

- **`bin/`**: Entry points called by asdf (download, install, list-all, latest-stable)
- **`lib/utils.py`**: Core Python logic for fetching the Zig version index, resolving platform-specific download URLs, and downloading tarballs with SHA256 verification
- **`lib/commands/`**: Additional asdf subcommands (mirror management)

The download flow:
1. `bin/download` calls `lib/utils.py download` which fetches from ziglang.org/download/index.json
2. Tries community mirrors (randomized order) before falling back to official source
3. Downloads both Zig and ZLS tarballs, verifies SHA256 checksums
4. `bin/install` extracts and places binaries in the asdf install path

## Common Commands

```bash
# Format shell scripts
make fmt

# Check formatting (CI uses this)
make fmt-check

# Lint with shellcheck
make lint

# Run tests (requires bats)
make test
```

## Environment Variables

- `ASDF_ZIG_INDEX_URL`: Override the Zig version index URL (default: https://ziglang.org/download/index.json)
- `ASDF_ZIG_HTTP_TIMEOUT`: HTTP request timeout in seconds (default: 30)

## Code Style

- Shell scripts: 2-space indentation, `shfmt -s -i 2 -ci`
- Python: single quotes for strings (configured in `.ruff.toml`)
- All files: UTF-8, trim trailing whitespace, final newline (`.editorconfig`)

## CI

GitHub Actions runs on push to main/master and PRs:
- Ruff for Python linting
- Tests download and install Zig 0.15.1 on Ubuntu and macOS
- asdf plugin-test validates the plugin works with asdf
