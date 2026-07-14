# SPEC -- nix-shebang

## S.G Goal

Pure Nix library for shebang operations -- strip, parse, wrap shell fragments into derivations. Write shell scripts as standalone testable files, compose them into nix packages declaratively. One-liner wire into any flake. 1-to-1 unit test coverage via nix-unit.

## S.C Constraints

- C1: Pure Nix only -- no compiled code, no external deps beyond nixpkgs
- C2: Pin nixpkgs via nixpkgs-lock (nixos-25.11)
- C3: nix-unit for all lib functions, wired into `nix flake check`
- C4: 1-to-1 test coverage: every `nix/lib/*.nix` has matching `nix/tests/unit/*.nix`
- C5: CI on three platforms: x86_64-linux, aarch64-linux, aarch64-darwin
- C6: Cache to cachix pr0d1r2.cachix.org
- C7: MIT license
- C8: LLM-generated, validated via CI
- C9: Universal shebang handling -- any interpreter, not just bash

## S.I Interfaces

- I.lib: `nix-shebang.lib` -- unified API: strip, readWithout, has, get, parse, isBash, isSh, isShellScript, toShellScript, toShellApplication, toTextFile
- I.flake-input: `inputs.nix-shebang.url = "github:pr0d1r2/nix-shebang"` -- one-liner wire
- I.checks: `nix flake check` -- runs all nix-unit tests as derivation
- I.dev: `nix develop` -- shell with nix-unit and nixfmt

## S.A API

### strip.nix

| Function | Signature | Purpose |
|----------|-----------|---------|
| strip | string → string | Remove first line if shebang |
| stripStrict | string → string | Remove shebang + `set -euo pipefail` |
| readWithout | path → string | readFile + strip |
| readWithoutStrict | path → string | readFile + stripStrict |
| has | string → bool | Does text start with `#!`? |
| get | string → string\|null | Extract shebang line or null |

### parse.nix

| Function | Signature | Purpose |
|----------|-----------|---------|
| parse | string → attrset\|null | `{ interpreter, args, isEnv, resolvedInterpreter }` |
| isBash | string → bool | Shebang resolves to bash |
| isSh | string → bool | Shebang resolves to sh |
| isShellScript | string → bool | Shebang resolves to bash or sh |

### wrap.nix

| Function | Signature | Purpose |
|----------|-----------|---------|
| toShellScript | { pkgs, name, src } → derivation | Fragment → writeShellScriptBin (strips shebang) |
| toShellApplication | { pkgs, name, src, meta? } → derivation | Fragment → writeShellApplication (strips shebang + set flags) |
| toTextFile | { pkgs, name, src } → derivation | Fragment → writeTextFile (preserves shebang) |

## S.U Usage

### One-liner wire

```nix
inputs.nix-shebang.url = "github:pr0d1r2/nix-shebang";
```

### In module

```nix
{ pkgs, nix-shebang, ... }:
let
  shebang = nix-shebang.lib;
in
{
  home.packages = [
    (shebang.toShellScript { inherit pkgs; name = "my-tool"; src = ./fragments/my-tool.sh; })
  ];
  programs.zsh.initContent = shebang.readWithout ./fragments/init.sh;
}
```

## S.V Invariants

- V1: Every `nix/lib/*.nix` has matching `nix/tests/unit/*.nix`
- V2: `nix flake check` passes on all three platforms
- V3: `strip` is universal -- works with any shebang (bash, sh, python, perl, etc.)
- V4: `strip` preserves text without shebang unchanged
- V5: `stripStrict` only removes `set -euo pipefail` if it immediately follows shebang
- V6: `readWithout` returns same as `strip (builtins.readFile path)`
- V7: `parse` returns null for non-shebang text
- V8: All tests use `test` prefix in attr names (nix-unit requirement)

## S.T Tasks

| id | st | desc | cites |
|----|----|------|-------|
| T1 | x | nix/lib/strip.nix: strip, stripStrict, readWithout, readWithoutStrict, has, get | C1,C9,V3,V4,V5 |
| T2 | x | nix/lib/parse.nix: parse, isBash, isSh, isShellScript | C1,C9,V7 |
| T3 | x | nix/lib/wrap.nix: toShellScript, toShellApplication, toTextFile | C1,I.lib |
| T4 | x | nix/lib/default.nix: unified API entry point | I.lib |
| T5 | x | nix/tests/unit/strip.nix: 14 tests | C3,C4,V1,V8 |
| T6 | x | nix/tests/unit/parse.nix: 17 tests | C3,C4,V1,V8 |
| T7 | x | nix/tests/unit/wrap.nix: 3 tests | C3,C4,V1,V8 |
| T8 | x | flake.nix: lib output, checks, devShell, nixpkgs-lock | C2,C5,I.checks,I.dev |
| T9 | x | CI: GitHub Actions matrix (linux, linux-arm, macos) + cachix | C5,C6 |
| T10 | . | Create GitHub repo (pr0d1r2/nix-shebang) | C7 |
| T11 | . | Protect main branch, require PRs | |
| T12 | . | Wire into nix-config as flake input | I.flake-input |
| T13 | . | Add update-pins.yml cron workflow | |

## S.B Bugs

| id | st | desc |
|----|----|------|
| B1 | x | `stripStrict` crashed on single-line shebang (no newline after `#!`): `builtins.head` on empty list |
| B2 | x | `isSh` and `isShellScript` missed `/usr/bin/sh` path (inconsistent with `isBash` which included `/usr/bin/bash`) |
| B3 | x | set-and-setting migration was incomplete: `fragments` declared `[base nix]` but repo's `.md`/`.yml` files detect as `[base nix ascii markdown yaml]` (guardrails fidelity FAIL). Fix: declare all detected fragments; add `mat.packages` to the `confirm` app `runtimeInputs` (coherence: markdownlint/yamllint wrappers on PATH); seed the missing `config/lefthook/file_size_limits.yml` (file-size-check) and `.nix-embedded-shell-allowlist` = `flake.nix` (nix-no-embedded-shell allows the confirm app's embedded shell) |
