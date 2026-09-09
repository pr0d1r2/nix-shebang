{ lib }:
let
  strip = import ../../lib/strip.nix { inherit lib; };
in
{
  testStripRemovesBashShebang = {
    expr = strip.strip "#!/usr/bin/env bash\necho hello\n";
    expected = "echo hello\n";
  };

  testStripRemovesShShebang = {
    expr = strip.strip "#!/bin/sh\necho hello";
    expected = "echo hello";
  };

  testStripRemovesPythonShebang = {
    expr = strip.strip "#!/usr/bin/env python3\nprint('hi')";
    expected = "print('hi')";
  };

  testStripPreservesTextWithoutShebang = {
    expr = strip.strip "echo hello";
    expected = "echo hello";
  };

  testStripPreservesTrailingNewline = {
    expr = strip.strip "#!/usr/bin/env bash\necho hello\n";
    expected = "echo hello\n";
  };

  testStripPreservesMultilineContent = {
    expr = strip.strip "#!/usr/bin/env bash\nset -euo pipefail\necho hello\n";
    expected = "set -euo pipefail\necho hello\n";
  };

  testStripStrictRemovesShebangAndSetFlags = {
    expr = strip.stripStrict "#!/usr/bin/env bash\nset -euo pipefail\necho hello\n";
    expected = "echo hello\n";
  };

  testStripStrictOnlyRemovesShebangWhenNoSetFlags = {
    expr = strip.stripStrict "#!/usr/bin/env bash\necho hello\n";
    expected = "echo hello\n";
  };

  testStripStrictHandlesSingleLineShebang = {
    expr = strip.stripStrict "#!/bin/bash";
    expected = "";
  };

  testStripStrictPreservesTextWithoutShebang = {
    expr = strip.stripStrict "echo hello";
    expected = "echo hello";
  };

  testStripPreambleRemovesShebangCommentsAndSet = {
    expr = strip.stripPreamble "#!/bin/sh\n# Header\n\nset -euo pipefail\necho hello\n";
    expected = "echo hello\n";
  };

  testStripPreambleRemovesNonStandardSetFlags = {
    expr = strip.stripPreamble "#!/bin/sh\nset -uo pipefail\necho hello";
    expected = "echo hello";
  };

  testStripPreamblePreservesTextWithoutShebang = {
    expr = strip.stripPreamble "# Header\necho hello";
    expected = "# Header\necho hello";
  };

  testStripPreambleStopsAtFirstCodeLine = {
    expr = strip.stripPreamble "#!/bin/sh\n# Header\necho hello\n# Keep this comment\n";
    expected = "echo hello\n# Keep this comment\n";
  };

  testStripPreambleHandlesAllPreambleFile = {
    expr = strip.stripPreamble "#!/bin/sh\n# Header\n\nset -uo pipefail\n";
    expected = "";
  };

  testReadWithoutPreambleMatchesStripPreamble =
    let
      path = builtins.toFile "strip-preamble-test.sh" "#!/bin/sh\n# Header\nset -euo pipefail\necho hello\n";
    in
    {
      expr = strip.readWithoutPreamble path;
      expected = strip.stripPreamble (builtins.readFile path);
    };

  testHasReturnsTrueForShebangText = {
    expr = strip.has "#!/usr/bin/env bash\necho hello";
    expected = true;
  };

  testHasReturnsFalseForNonShebangText = {
    expr = strip.has "echo hello";
    expected = false;
  };

  testGetReturnsShebangLine = {
    expr = strip.get "#!/usr/bin/env bash\necho hello";
    expected = "#!/usr/bin/env bash";
  };

  testGetReturnsNullForNonShebangText = {
    expr = strip.get "echo hello";
    expected = null;
  };
}
