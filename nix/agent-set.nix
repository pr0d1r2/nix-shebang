# Declarative skill set built from set-and-setting. Leaf module — consumed by
# the skills app (sync) and exposed as the agent-set package.
{ pkgs, set-and-setting }:
set-and-setting.lib.mkSet {
  inherit pkgs;
  categories = [
    "opensource"
    "nix"
    "ci"
    "lefthook"
    "git"
    "test"
  ];
}
