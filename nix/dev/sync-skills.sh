# shellcheck shell=bash
# Sync the built agent-set into gitignored .claude/. No nix interpolation —
# AGENT_SET (store path) is injected by the wrapping writeShellApplication.
# Layout: set.md sits beside set/ so its `@./set/...` imports resolve.
dst=.claude/skills
mkdir -p "$dst/set"
rm -rf "$dst/set/skills" "$dst/set/concepts" "$dst/set.md"
cp "$AGENT_SET/set.md" "$dst/set.md"
cp -r "$AGENT_SET/skills" "$dst/set/skills"
cp -r "$AGENT_SET/concepts" "$dst/set/concepts"
chmod -R u+w "$dst"
echo "synced skills -> $dst/set"
