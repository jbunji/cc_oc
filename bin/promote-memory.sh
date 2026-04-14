#!/usr/bin/env bash
# promote-memory.sh — promote marked bullets from a daily note into MEMORY.md
#
# Convention in daily notes:
#   <!-- promote: -->
#   - bullet one
#   - bullet two
#
# Parsing stops at: blank line, next "### ", or next "<!--".
# Dry-run by default. Use --apply to write.

set -euo pipefail

SOUL_DIR="/home/parallels/soul"
MEMORY="$SOUL_DIR/MEMORY.md"
DAILY_DIR="$SOUL_DIR/daily"
REBUILD="$SOUL_DIR/bin/rebuild-bootstrap.sh"

APPLY=0
DATE="$(date +%F)"
for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=1 ;;
    --date=*) DATE="${arg#--date=}" ;;
    -h|--help)
      echo "Usage: $0 [--date=YYYY-MM-DD] [--apply]"
      exit 0
      ;;
    *) echo "unknown arg: $arg" >&2; exit 2 ;;
  esac
done

DAILY="$DAILY_DIR/$DATE.md"
[[ -f "$DAILY" ]] || { echo "no daily note at $DAILY" >&2; exit 1; }

# Extract bullets that follow a <!-- promote: --> marker.
BULLETS="$(awk '
  /<!-- promote: -->/ { inblock=1; next }
  inblock {
    if ($0 ~ /^[[:space:]]*$/) { inblock=0; next }
    if ($0 ~ /^### /)          { inblock=0; next }
    if ($0 ~ /<!--/)           { inblock=0; next }
    if ($0 ~ /^[[:space:]]*-/) { print; next }
    inblock=0
  }
' "$DAILY")"

if [[ -z "$BULLETS" ]]; then
  echo "nothing marked for promotion in $DAILY"
  exit 0
fi

COUNT=$(printf '%s\n' "$BULLETS" | grep -c '^')
echo "=== Promotion preview ($COUNT items from $DATE) ==="
printf '%s\n' "$BULLETS"
echo "==="

if [[ $APPLY -eq 0 ]]; then
  echo "(dry-run — re-run with --apply to write)"
  exit 0
fi

STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$MEMORY.bak.$STAMP"
cp "$MEMORY" "$BACKUP"
echo "backup: $BACKUP"

{
  printf '\n## Promoted from daily/%s.md\n' "$DATE"
  printf '%s\n' "$BULLETS"
} >> "$MEMORY"

# Mark consumed markers so reruns are idempotent.
sed -i 's|<!-- promote: -->|<!-- promoted: -->|g' "$DAILY"

echo "appended $COUNT items to $MEMORY"

if [[ -x "$REBUILD" ]]; then
  "$REBUILD"
  echo "bootstrap rebuilt"
else
  echo "warn: $REBUILD not executable — skipping rebuild" >&2
fi
