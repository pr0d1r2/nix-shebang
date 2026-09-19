# Changelog

Notable changes are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/); the project aims to
follow semantic versioning.

## Unreleased

### Fixed

- `isSh` and `isShellScript` now recognize `/usr/bin/sh` (was missing
  while `isBash` already included `/usr/bin/bash`)
- `lib` and `tests` are exposed again, and `nix flake check` runs the
  `unit-tests` assertions again -- the set-and-setting migration had
  replaced the outputs with a bare `mkConsumerFlake` call, which
  publishes only the standard's outputs, so `nix-shebang.lib` failed to
  evaluate for consumers
- The flake description says what the flake is instead of `CHANGEME`
- `lib`, `tests` and the `unit-tests` check are restored a second time:
  the 2026-09-07 migration run regenerated `flake.nix` from the template
  again and dropped the `nix/outputs.nix` import (B10). The `actions`
  fragment it added is kept, now declared in `nix/outputs.nix`

### Added

- `vectors` -- 13 shared test vectors (`nix/tests/vectors.nix`), each
  asserted for every text function and exported for ports in other
  languages (`nix eval --json .#vectors`)
- `strip`, `stripStrict`, `readWithout`, `readWithoutStrict`, `has`,
  `get` -- strip and extract shebang lines
- `parse`, `isBash`, `isSh`, `isShellScript` -- parse a shebang into its
  interpreter and arguments
- `toShellScript`, `toShellApplication`, `toTextFile` -- wrap shell
  fragments into derivations
- nix-unit test suite with 1-to-1 coverage, wired into `nix flake check`
- Engineering skills and project standards sourced from set-and-setting
  via gitignored out-links
