# apps output. `nix run .#skills` materializes the skill set into .claude/.
{ pkgs, agentSet }:
let
  sync-skills = pkgs.writeShellApplication {
    name = "sync-skills";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      export AGENT_SET="${agentSet}"
    ''
    + builtins.readFile ./dev/sync-skills.sh;
  };
in
{
  skills = {
    type = "app";
    program = "${sync-skills}/bin/sync-skills";
  };
}
