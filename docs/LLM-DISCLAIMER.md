# LLM-Generated Code Disclaimer

<!-- hallucinogen:tending-disclaimer start -->
**Tended by an autonomous loop running Codex with GPT-5.6 luna at low
reasoning effort.** When Codex is unavailable the loop falls back to Claude,
then to a local model. The loop opens pull requests, reviews them itself
and merges them once they are green, without a human reading the diff: the
merge gate is this repository's own checks plus that automated review, not
human approval. On top of that, the maintainer runs periodic meta-reviews
with agents and corrects drift or bugs they find.

What keeps that checkable is mechanical rather than a matter of trust:
the loop generates tests and linter configurations, so its gates give
the same answer every time, and it builds command-line tools, with clear
documentation, that a person can use to inspect the same state the loop sees.

Some classes of change are held for a human by design: releases, anything
touching the loop's own safety rails, and anything that could publish to
a package registry. Everything else is not.

**Origin.** This project was originally written with LLM assistance,
with a human reviewing every change. The text below records that period:
what it says about human review holds for the code written then, not for
the merges the loop makes now.

---
<!-- hallucinogen:tending-disclaimer end -->

This project contains code that was generated, reviewed, and validated by Large Language Models (LLMs) as part of the development process.

## Scope

Per constraint C8 in [SPEC.md](../SPEC.md), this codebase is "LLM-generated, validated via CI". The following components were created with LLM assistance:

- Core library functions in `nix/lib/*.nix`
- Unit tests in `nix/tests/unit/*.nix`
- Test vectors in `nix/tests/vectors.nix`

## Validation

All LLM-generated code is validated through:

- Automated CI pipeline on three platforms (x86_64-linux, aarch64-linux, aarch64-darwin)
- Unit test coverage (1-to-1 ratio per constraint C4)
- Human code review and manual testing
- Functional verification against the project specification

## Code Quality

The use of LLM assistance does not diminish the quality or reliability guarantees:

- All functionality is covered by automated tests
- Results are cached and reproducible via Nix
- The library maintains pure Nix semantics without external dependencies
- Output is validated against published test vectors

## Licensing

This project is licensed under the MIT License (see [LICENSE](../LICENSE)). LLM-generated code is subject to the same license terms as hand-written code within this repository.

## Reproduction

Users can verify the behavior of all library functions by:

```bash
nix eval --json github:pr0d1r2/nix-shebang#vectors
```

This exports shared test vectors that define expected behavior, which can be used to validate ports in other languages or alternative implementations.
