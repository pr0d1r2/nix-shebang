# nix-shebang

<!-- hallucinogen:autonomy-disclaimer start -->
> Read [LLM-DISCLAIMER](docs/LLM-DISCLAIMER.md) first. This repository is
> tended by an autonomous loop, and that file says what the loop may do here,
> what it may not, and what to check before trusting anything in this tree.
<!-- hallucinogen:autonomy-disclaimer end -->

[![CI](https://github.com/pr0d1r2/nix-shebang/actions/workflows/ci.yml/badge.svg)](https://github.com/pr0d1r2/nix-shebang/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![NixOS 26.05](https://img.shields.io/badge/NixOS-26.05-blue.svg?logo=nixos)](https://nixos.org)

Pure Nix library for shebang operations — strip, parse, and wrap shell
fragments into derivations. Write shell scripts as standalone, testable files,
then compose them into Nix packages declaratively. Works with any interpreter,
not just bash.

## Why

Embedding shell in Nix string literals is untestable and unlintable. Keep shell
in real `.sh` files with a shebang (so editors and `shellcheck` work), then pull
them into Nix — stripping or preserving the shebang as needed.

## Usage

Wire it into your flake:

```nix
inputs.nix-shebang.url = "github:pr0d1r2/nix-shebang";
```

Use the unified API via `nix-shebang.lib`:

```nix
{ pkgs, nix-shebang, ... }:
let
  shebang = nix-shebang.lib;
in
{
  # Fragment file → executable derivation (shebang stripped)
  home.packages = [
    (shebang.toShellScript {
      inherit pkgs;
      name = "my-tool";
      src = ./fragments/my-tool.sh;
    })
  ];

  # Inline a fragment as text, shebang removed
  programs.zsh.initContent = shebang.readWithout ./fragments/init.sh;
}
```

## API

### Strip

| Function | Signature | Purpose |
| --- | --- | --- |
| `strip` | string → string | Remove first line if shebang |
| `stripStrict` | string → string | Remove shebang + `set -euo pipefail` |
| `readWithout` | path → string | `readFile` + `strip` |
| `readWithoutStrict` | path → string | `readFile` + `stripStrict` |
| `has` | string → bool | Does text start with `#!`? |
| `get` | string → string \| null | Extract shebang line or null |

### Parse

| Function | Signature | Purpose |
| --- | --- | --- |
| `parse` | string → attrset \| null | `{ interpreter, args, isEnv, resolvedInterpreter }` |
| `isBash` | string → bool | Shebang resolves to bash |
| `isSh` | string → bool | Shebang resolves to sh |
| `isShellScript` | string → bool | Shebang resolves to bash or sh |

### Wrap

| Function | Signature | Purpose |
| --- | --- | --- |
| `toShellScript` | `{ pkgs, name, src }` → derivation | → `writeShellScriptBin` (strips shebang) |
| `toShellApplication` | `{ pkgs, name, src, meta? }` → derivation | → `writeShellApplication` (strips shebang + set flags) |
| `toTextFile` | `{ pkgs, name, src }` → derivation | → `writeTextFile` (preserves shebang) |

## Test vectors

`nix-shebang.vectors` is the library's behaviour as data: one row per input,
with the expected result of `has`, `get`, `strip`, `stripStrict`, `parse`,
`isBash`, `isSh` and `isShellScript`. The unit tests assert every row, so the
vectors cannot drift from `lib`. A port in another language can check
identical behaviour against them:

```bash
nix eval --json github:pr0d1r2/nix-shebang#vectors
```

Rows pin current behaviour, limits included: `envSplitString` records that
`parse` does not understand `env -S`.

## Development

```bash
nix develop          # shell with nix-unit + nixfmt
nix flake check      # run all unit tests on this platform
```

Tests use [nix-unit](https://github.com/nix-community/nix-unit) with 1-to-1
coverage: every `nix/lib/*.nix` has a matching `nix/tests/unit/*.nix`. See
[SPEC.md](SPEC.md) for the full specification.

## License

MIT — see [LICENSE](LICENSE).
