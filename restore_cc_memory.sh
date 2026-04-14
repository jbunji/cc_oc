#!/usr/bin/env bash
set -euo pipefail

# Claude Code Soul/Memory restore script
# Usage:
#   ./restore_cc_memory.sh /path/to/cc_oc

SRC="${1:-}"
if [[ -z "$SRC" ]]; then
  echo "usage: $0 /path/to/source-repo"
  exit 1
fi

SRC="$(cd "$SRC" && pwd)"
HOME_DIR="$HOME"
SOUL_DST="$HOME_DIR/soul"
CLAUDE_DST="$HOME_DIR/.claude"
BIN_DST="$HOME_DIR/bin"

echo "==> Source: $SRC"
echo "==> Target home: $HOME_DIR"

mkdir -p "$SOUL_DST" "$CLAUDE_DST" "$BIN_DST"

backup_if_exists() {
  local target="$1"
  if [[ -e "$target" ]]; then
    local ts
    ts="$(date +%Y%m%d-%H%M%S)"
    mv "$target" "${target}.bak-${ts}"
    echo "backed up existing: $target -> ${target}.bak-${ts}"
  fi
}

copy_dir_contents() {
  local src="$1"
  local dst="$2"
  mkdir -p "$dst"
  cp -a "$src"/. "$dst"/
}

backup_if_exists "$SOUL_DST"
backup_if_exists "$CLAUDE_DST"

mkdir -p "$SOUL_DST" "$CLAUDE_DST"

if [[ -d "$SRC/soul" ]]; then
  echo "==> Copying soul/"
  copy_dir_contents "$SRC/soul" "$SOUL_DST"
else
  echo "ERROR: $SRC/soul not found"
  exit 1
fi

if [[ -d "$SRC/.claude" ]]; then
  echo "==> Copying .claude/"
  copy_dir_contents "$SRC/.claude" "$CLAUDE_DST"
else
  echo "ERROR: $SRC/.claude not found"
  exit 1
fi

if [[ -f "$SRC/mem" ]]; then
  echo "==> Installing mem helper"
  cp -f "$SRC/mem" "$HOME_DIR/mem"
fi

if [[ -f "$SRC/claudej" ]]; then
  echo "==> Installing claudej launcher"
  cp -f "$SRC/claudej" "$BIN_DST/claudej"
fi

echo "==> Rewriting hardcoded /home/parallels paths to $HOME_DIR"
find "$SOUL_DST" "$CLAUDE_DST" "$HOME_DIR" -maxdepth 3 -type f \
  \( -name "*.sh" -o -name "*.md" -o -name "mem" -o -name "claudej" -o -name "settings.json" \) \
  2>/dev/null | while read -r file; do
    python3 - "$file" "$HOME_DIR" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
home = sys.argv[2]
try:
    text = path.read_text(encoding="utf-8")
except Exception:
    raise SystemExit(0)

new = text.replace("/home/parallels", home)
if new != text:
    path.write_text(new, encoding="utf-8")
PY
done

mkdir -p "$SOUL_DST/daily" "$SOUL_DST/review" "$SOUL_DST/bin" "$CLAUDE_DST/hooks"
touch "$SOUL_DST/review/queue.jsonl"
touch "$SOUL_DST/RECENT_WORK.md"

echo "==> Fixing permissions"
find "$SOUL_DST/bin" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
[[ -f "$CLAUDE_DST/hooks/append-session-note.sh" ]] && chmod +x "$CLAUDE_DST/hooks/append-session-note.sh"
[[ -f "$HOME_DIR/mem" ]] && chmod +x "$HOME_DIR/mem"
[[ -f "$BIN_DST/claudej" ]] && chmod +x "$BIN_DST/claudej"

if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$HOME_DIR/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME_DIR/.bashrc"
  echo "==> Added ~/bin to PATH in ~/.bashrc"
fi

if [[ -x "$SOUL_DST/bin/rebuild-bootstrap.sh" ]]; then
  echo "==> Rebuilding bootstrap"
  "$SOUL_DST/bin/rebuild-bootstrap.sh"
else
  echo "WARNING: rebuild-bootstrap.sh not found or not executable"
fi

cat <<EOF

Restore complete.

Next steps:
1. Start a new shell or run:
   source ~/.bashrc

2. Verify Claude Code hook config:
   cat ~/.claude/settings.json

3. Start Claude with:
   claudej

4. Inside Claude Code, verify hooks with:
   /hooks

5. If Claude Code is not installed or not logged in yet:
   claude
   # then log in

EOF
