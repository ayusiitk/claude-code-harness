#!/usr/bin/env bash
# Install this harness (skills, hook, permission settings) into another
# project. Safe to re-run: vendored files are overwritten, but settings.json
# and CLAUDE.md are merged rather than clobbered.
#
# Usage:
#   ./install.sh [path-to-target-repo]     # defaults to .
set -euo pipefail

HARNESS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-.}"

if [ ! -d "$HARNESS_ROOT/.claude/skills" ]; then
  echo "error: $HARNESS_ROOT does not look like a harness checkout (no .claude/skills)" >&2
  exit 1
fi

cd "$TARGET"
TARGET="$(pwd)"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "error: $TARGET is not a git repository — install into a repo, not a scratch directory" >&2
  exit 1
fi

echo "Installing harness from $HARNESS_ROOT into $TARGET"

# --- skills and hook: vendored, safe to overwrite file-for-file ---
mkdir -p "$TARGET/.claude"
rm -rf "$TARGET/.claude/skills"
cp -r "$HARNESS_ROOT/.claude/skills" "$TARGET/.claude/skills"
mkdir -p "$TARGET/.claude/hooks"
cp "$HARNESS_ROOT/.claude/hooks/session-start" "$TARGET/.claude/hooks/session-start"
chmod +x "$TARGET/.claude/hooks/session-start"
cp "$HARNESS_ROOT/NOTICE" "$TARGET/NOTICE"
mkdir -p "$TARGET/docs/agents"
cp "$HARNESS_ROOT/docs/agents/working-with-the-harness.md" \
   "$TARGET/docs/agents/working-with-the-harness.md"

# --- toolchain.md: seed once, then it's the target project's own ---
if [ -f "$TARGET/docs/agents/toolchain.md" ]; then
  echo "  left docs/agents/toolchain.md alone (already exists — this file is meant to diverge per project)"
else
  cp "$HARNESS_ROOT/docs/agents/toolchain.md" "$TARGET/docs/agents/toolchain.md"
  echo "  seeded docs/agents/toolchain.md (template — fill in this project's real commands)"
fi

# --- settings.json: merge allow/ask arrays, never clobber ---
if [ -f "$TARGET/.claude/settings.json" ]; then
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$HARNESS_ROOT/.claude/settings.json" "$TARGET/.claude/settings.json" <<'PY'
import json, sys
harness_path, target_path = sys.argv[1], sys.argv[2]
harness = json.load(open(harness_path))
target = json.load(open(target_path))

target.setdefault("permissions", {})
target["permissions"].setdefault("defaultMode", harness["permissions"]["defaultMode"])
for key in ("allow", "ask"):
    existing = target["permissions"].get(key, [])
    incoming = harness["permissions"].get(key, [])
    target["permissions"][key] = sorted(set(existing) | set(incoming))

target.setdefault("hooks", harness.get("hooks", {}))

with open(target_path, "w") as f:
    json.dump(target, f, indent=2)
    f.write("\n")
PY
    echo "  merged .claude/settings.json (union of allow/ask rules, existing entries kept)"
  else
    echo "  WARNING: python3 not found — .claude/settings.json left as-is." >&2
    echo "  Merge $HARNESS_ROOT/.claude/settings.json into it by hand." >&2
  fi
else
  cp "$HARNESS_ROOT/.claude/settings.json" "$TARGET/.claude/settings.json"
  echo "  wrote .claude/settings.json (no existing file)"
fi

# --- CLAUDE.md: append the harness block under delimiter markers, idempotent ---
START_MARKER="<!-- claude-code-harness:start -->"
END_MARKER="<!-- claude-code-harness:end -->"
BLOCK_FILE="$(mktemp)"
trap 'rm -f "$BLOCK_FILE"' EXIT
{
  echo "$START_MARKER"
  cat "$HARNESS_ROOT/CLAUDE.md"
  echo "$END_MARKER"
} > "$BLOCK_FILE"

TARGET_CLAUDE_MD="$TARGET/CLAUDE.md"
if [ -f "$TARGET_CLAUDE_MD" ] && grep -qF "$START_MARKER" "$TARGET_CLAUDE_MD"; then
  python3 - "$TARGET_CLAUDE_MD" "$BLOCK_FILE" "$START_MARKER" "$END_MARKER" <<'PY'
import sys
target_path, block_path, start, end = sys.argv[1:5]
target = open(target_path).read()
block = open(block_path).read()
pre, _, rest = target.partition(start)
_, _, post = rest.partition(end)
open(target_path, "w").write(pre + block.rstrip("\n") + post)
PY
  echo "  updated the harness block in CLAUDE.md (re-run detected)"
elif [ -f "$TARGET_CLAUDE_MD" ]; then
  {
    cat "$TARGET_CLAUDE_MD"
    echo
    cat "$BLOCK_FILE"
  } > "$TARGET_CLAUDE_MD.new"
  mv "$TARGET_CLAUDE_MD.new" "$TARGET_CLAUDE_MD"
  echo "  appended the harness block to the existing CLAUDE.md"
else
  cp "$BLOCK_FILE" "$TARGET_CLAUDE_MD"
  echo "  wrote CLAUDE.md (no existing file)"
fi

cat <<SUMMARY

Done. Skills installed, no further setup needed.

Next steps:
  - Run 'git diff' in $TARGET to review what changed.
  - Add this project's own test/lint/typecheck commands to
    .claude/settings.json's "allow" list.
  - Fill in docs/agents/toolchain.md with this project's real commands
    (copy the harness's docs/agents/toolchain.md if you don't have one yet).
SUMMARY
