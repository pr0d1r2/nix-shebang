# SHARED TEST VECTORS -- one row per input, the expected result of every
# text function in `lib`. Pure data: the unit tests assert every row
# (tests/unit/strip.nix, tests/unit/parse.nix) and the flake exports it as
# `vectors`, so a port in another language can assert identical behaviour:
#
#   nix eval --json github:pr0d1r2/nix-shebang#vectors
#
# A row PINS current behaviour, limits included -- `envSplitString` records
# that `parse` does not understand `env -S`. Changing behaviour means changing
# the row in the same commit.
[
  {
    name = "envBash";
    input = "#!/usr/bin/env bash\necho hello\n";
    has = true;
    get = "#!/usr/bin/env bash";
    strip = "echo hello\n";
    stripStrict = "echo hello\n";
    stripPreamble = "echo hello\n";
    parse = {
      args = [ "bash" ];
      interpreter = "/usr/bin/env";
      isEnv = true;
      resolvedInterpreter = "bash";
    };
    isBash = true;
    isSh = false;
    isShellScript = true;
  }
  {
    name = "envBashStrict";
    input = "#!/usr/bin/env bash\nset -euo pipefail\necho hello\n";
    has = true;
    get = "#!/usr/bin/env bash";
    strip = "set -euo pipefail\necho hello\n";
    stripStrict = "echo hello\n";
    stripPreamble = "echo hello\n";
    parse = {
      args = [ "bash" ];
      interpreter = "/usr/bin/env";
      isEnv = true;
      resolvedInterpreter = "bash";
    };
    isBash = true;
    isSh = false;
    isShellScript = true;
  }
  {
    name = "binBashStrictOnly";
    input = "#!/bin/bash\nset -euo pipefail\n";
    has = true;
    get = "#!/bin/bash";
    strip = "set -euo pipefail\n";
    stripStrict = "";
    stripPreamble = "";
    parse = {
      args = [ ];
      interpreter = "/bin/bash";
      isEnv = false;
      resolvedInterpreter = "/bin/bash";
    };
    isBash = true;
    isSh = false;
    isShellScript = true;
  }
  {
    name = "binSh";
    input = "#!/bin/sh\necho hello";
    has = true;
    get = "#!/bin/sh";
    strip = "echo hello";
    stripStrict = "echo hello";
    stripPreamble = "echo hello";
    parse = {
      args = [ ];
      interpreter = "/bin/sh";
      isEnv = false;
      resolvedInterpreter = "/bin/sh";
    };
    isBash = false;
    isSh = true;
    isShellScript = true;
  }
  {
    name = "usrBinSh";
    input = "#!/usr/bin/sh\necho hi\n";
    has = true;
    get = "#!/usr/bin/sh";
    strip = "echo hi\n";
    stripStrict = "echo hi\n";
    stripPreamble = "echo hi\n";
    parse = {
      args = [ ];
      interpreter = "/usr/bin/sh";
      isEnv = false;
      resolvedInterpreter = "/usr/bin/sh";
    };
    isBash = false;
    isSh = true;
    isShellScript = true;
  }
  {
    name = "envPython";
    input = "#!/usr/bin/env python3\nprint('hi')";
    has = true;
    get = "#!/usr/bin/env python3";
    strip = "print('hi')";
    stripStrict = "print('hi')";
    stripPreamble = "print('hi')";
    parse = {
      args = [ "python3" ];
      interpreter = "/usr/bin/env";
      isEnv = true;
      resolvedInterpreter = "python3";
    };
    isBash = false;
    isSh = false;
    isShellScript = false;
  }
  {
    name = "awkProgram";
    input = "#!/usr/bin/awk -f\n{ print $1 }\n";
    has = true;
    get = "#!/usr/bin/awk -f";
    strip = "{ print $1 }\n";
    stripStrict = "{ print $1 }\n";
    stripPreamble = "{ print $1 }\n";
    parse = {
      args = [ "-f" ];
      interpreter = "/usr/bin/awk";
      isEnv = false;
      resolvedInterpreter = "/usr/bin/awk";
    };
    isBash = false;
    isSh = false;
    isShellScript = false;
  }
  {
    name = "envSplitString";
    input = "#!/usr/bin/env -S jq -f\n.foo\n";
    has = true;
    get = "#!/usr/bin/env -S jq -f";
    strip = ".foo\n";
    stripStrict = ".foo\n";
    stripPreamble = ".foo\n";
    parse = {
      args = [
        "-S"
        "jq"
        "-f"
      ];
      interpreter = "/usr/bin/env";
      isEnv = true;
      resolvedInterpreter = "-S";
    };
    isBash = false;
    isSh = false;
    isShellScript = false;
  }
  {
    name = "shebangOnly";
    input = "#!/bin/bash";
    has = true;
    get = "#!/bin/bash";
    strip = "";
    stripStrict = "";
    stripPreamble = "";
    parse = {
      args = [ ];
      interpreter = "/bin/bash";
      isEnv = false;
      resolvedInterpreter = "/bin/bash";
    };
    isBash = true;
    isSh = false;
    isShellScript = true;
  }
  {
    name = "strictNotFirst";
    input = "#!/bin/bash\necho a\nset -euo pipefail\n";
    has = true;
    get = "#!/bin/bash";
    strip = "echo a\nset -euo pipefail\n";
    stripStrict = "echo a\nset -euo pipefail\n";
    stripPreamble = "echo a\nset -euo pipefail\n";
    parse = {
      args = [ ];
      interpreter = "/bin/bash";
      isEnv = false;
      resolvedInterpreter = "/bin/bash";
    };
    isBash = true;
    isSh = false;
    isShellScript = true;
  }
  {
    name = "strictVariant";
    input = "#!/bin/bash\nset -eu\necho x\n";
    has = true;
    get = "#!/bin/bash";
    strip = "set -eu\necho x\n";
    stripStrict = "set -eu\necho x\n";
    stripPreamble = "echo x\n";
    parse = {
      args = [ ];
      interpreter = "/bin/bash";
      isEnv = false;
      resolvedInterpreter = "/bin/bash";
    };
    isBash = true;
    isSh = false;
    isShellScript = true;
  }
  {
    name = "noShebang";
    input = "echo hello";
    has = false;
    get = null;
    strip = "echo hello";
    stripStrict = "echo hello";
    stripPreamble = "echo hello";
    parse = null;
    isBash = false;
    isSh = false;
    isShellScript = false;
  }
  {
    name = "empty";
    input = "";
    has = false;
    get = null;
    strip = "";
    stripStrict = "";
    stripPreamble = "";
    parse = null;
    isBash = false;
    isSh = false;
    isShellScript = false;
  }
]
