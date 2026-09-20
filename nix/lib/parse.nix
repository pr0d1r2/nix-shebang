{ lib }:
let
  parseShebang =
    line:
    let
      withoutPrefix = lib.removePrefix "#!" line;
      # Shebangs commonly contain repeated whitespace; empty tokens must not
      # become interpreter arguments (especially for `/usr/bin/env`).
      parts = lib.filter (part: part != "") (lib.splitString " " (lib.trim withoutPrefix));
      interpreter = builtins.head parts;
      args = builtins.tail parts;
      envResolvedInterpreter =
        if args == [ ] then
          interpreter
        else if builtins.head args == "-S" || builtins.head args == "--split-string" then
          if builtins.length args > 1 then builtins.elemAt args 1 else interpreter
        else if lib.hasPrefix "-S" (builtins.head args) then
          lib.removePrefix "-S" (builtins.head args)
        else
          builtins.head args;
    in
    if lib.hasPrefix "#!" line then
      {
        inherit interpreter args;
        isEnv = interpreter == "/usr/bin/env";
        resolvedInterpreter = if interpreter == "/usr/bin/env" then envResolvedInterpreter else interpreter;
      }
    else
      null;
in
{
  parse =
    text:
    let
      first = builtins.head (lib.splitString "\n" text);
    in
    parseShebang first;

  isBash =
    text:
    let
      parsed = parseShebang (builtins.head (lib.splitString "\n" text));
    in
    parsed != null
    && builtins.elem parsed.resolvedInterpreter [
      "bash"
      "/bin/bash"
      "/usr/bin/bash"
    ];

  isSh =
    text:
    let
      parsed = parseShebang (builtins.head (lib.splitString "\n" text));
    in
    parsed != null
    && builtins.elem parsed.resolvedInterpreter [
      "sh"
      "/bin/sh"
      "/usr/bin/sh"
    ];

  isShellScript =
    text:
    let
      parsed = parseShebang (builtins.head (lib.splitString "\n" text));
    in
    parsed != null
    && builtins.elem parsed.resolvedInterpreter [
      "bash"
      "/bin/bash"
      "/usr/bin/bash"
      "sh"
      "/bin/sh"
      "/usr/bin/sh"
    ];
}
