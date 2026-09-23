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

TARGET="$(cd "$TARGET" && pwd)"

if [ "$TARGET" = "$HARNESS_ROOT" ]; then
  echo "error: target ($TARGET) is this harness checkout itself." >&2
  echo "  Run this from inside the project you want to install into, or pass its path." >&2
  exit 1
fi

if ! (cd "$TARGET" && git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
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

# --- settings.json: merge allow/ask arrays and the SessionStart hook, never clobber ---
if [ -f "$TARGET/.claude/settings.json" ]; then
  if command -v python3 >/dev/null 2>&1; then
    if ! python3 - "$HARNESS_ROOT/.claude/settings.json" "$TARGET/.claude/settings.json" <<'PY'
import json, sys

harness_path, target_path = sys.argv[1], sys.argv[2]

try:
    harness = json.load(open(harness_path))
    target = json.load(open(target_path))
except json.JSONDecodeError as e:
    print(f"  WARNING: {target_path} is not valid JSON ({e}) -- left as-is.", file=sys.stderr)
    print(f"  Merge {harness_path} into it by hand.", file=sys.stderr)
    sys.exit(1)

target.setdefault("permissions", {})
target["permissions"].setdefault("defaultMode", harness["permissions"]["defaultMode"])
for key in ("allow", "ask"):
    existing = target["permissions"].get(key, [])
    incoming = harness["permissions"].get(key, [])
    if not isinstance(existing, list) or not isinstance(incoming, list):
        print(
            f"  WARNING: permissions.{key} in {target_path} is not a list -- "
            "left that key as-is rather than risk corrupting it.",
            file=sys.stderr,
        )
        continue
    target["permissions"][key] = sorted(set(existing) | set(incoming))

harness_session_start = None
for entry in harness.get("hooks", {}).get("SessionStart", []):
    harness_session_start = entry
    break

if harness_session_start is not None:
    target.setdefault("hooks", {})
    existing_starts = target["hooks"].setdefault("SessionStart", [])
    if not isinstance(existing_starts, list):
        print(
            f"  WARNING: hooks.SessionStart in {target_path} is not a list -- "
            "left it as-is; add the harness's SessionStart hook by hand.",
            file=sys.stderr,
        )
    elif harness_session_start not in existing_starts:
        existing_starts.append(harness_session_start)

with open(target_path, "w") as f:
    json.dump(target, f, indent=2)
    f.write("\n")
PY
    then
      : # the python step already printed a WARNING and left the file as-is; keep going
    else
      echo "  merged .claude/settings.json (union of allow/ask rules and the SessionStart hook, existing entries kept)"
    fi
  else
    echo "  WARNING: python3 not found — .claude/settings.json left as-is." >&2
    echo "  Merge $HARNESS_ROOT/.claude/settings.json into it by hand." >&2
  fi
else
  cp "$HARNESS_ROOT/.claude/settings.json" "$TARGET/.claude/settings.json"
  echo "  wrote .claude/settings.json (no existing file)"
fi

# --- CLAUDE.md: append the harness block under delimiter markers, idempotent ---
if ! command -v python3 >/dev/null 2>&1; then
  echo "  WARNING: python3 not found — CLAUDE.md left as-is." >&2
  echo "  Append $HARNESS_ROOT/CLAUDE.md's content into it by hand, or copy it if the target has none." >&2
else
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
    if ! grep -qF "$END_MARKER" "$TARGET_CLAUDE_MD"; then
      echo "  WARNING: $TARGET_CLAUDE_MD has a start marker but no end marker -- left it untouched." >&2
      echo "  It was likely hand-edited; resolve the markers manually before re-running install.sh." >&2
    else
      python3 - "$TARGET_CLAUDE_MD" "$BLOCK_FILE" "$START_MARKER" "$END_MARKER" <<'PY'
import sys
target_path, block_path, start, end = sys.argv[1:5]
target = open(target_path).read()
block = open(block_path).read()
pre, _, rest = target.partition(start)
mid, found_end, post = rest.partition(end)
assert found_end, "end marker vanished between the grep check and here"
open(target_path, "w").write(pre + block.rstrip("\n") + post)
PY
      echo "  updated the harness block in CLAUDE.md (re-run detected)"
    fi
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
