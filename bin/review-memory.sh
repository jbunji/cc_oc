#!/usr/bin/env bash
# Interactive review of /home/parallels/soul/review/queue.jsonl
# Approve/edit/skip/drop items and promote approved ones into MEMORY.md.

set -euo pipefail

SOUL_DIR="/home/parallels/soul"
QUEUE="$SOUL_DIR/review/queue.jsonl"
MEMORY="$SOUL_DIR/MEMORY.md"
REBUILD="$SOUL_DIR/bin/rebuild-bootstrap.sh"
TODAY="$(date +%Y-%m-%d)"
HEADER="## Promoted from review/queue on $TODAY"

command -v jq >/dev/null || { echo "jq required"; exit 1; }
[[ -f "$QUEUE" ]] || { echo "No queue at $QUEUE"; exit 0; }

# Backup MEMORY.md once per run
cp "$MEMORY" "$MEMORY.bak.$(date +%Y%m%d-%H%M%S)"

append_bullet() {
  local text="$1"
  # Dedupe: skip if exact bullet already present
  if grep -Fqx "- $text" "$MEMORY"; then
    echo "  (already in MEMORY.md — skipping append)"
    return
  fi
  if ! grep -Fq "$HEADER" "$MEMORY"; then
    printf '\n%s\n' "$HEADER" >> "$MEMORY"
  fi
  printf -- '- %s\n' "$text" >> "$MEMORY"
}

# Read queue into an array of lines
mapfile -t LINES < "$QUEUE"
TOTAL=${#LINES[@]}
CHANGED=0

for i in "${!LINES[@]}"; do
  line="${LINES[$i]}"
  [[ -z "$line" ]] && continue

  status=$(jq -r '.status // "pending"' <<<"$line")
  [[ "$status" != "pending" ]] && continue

  kind=$(jq -r '.kind // "unknown"' <<<"$line")
  text=$(jq -r '.text // ""' <<<"$line")
  excerpt=$(jq -r '.source_excerpt // ""' <<<"$line")

  echo
  echo "──────── item $((i+1))/$TOTAL ────────"
  echo "kind: $kind"
  echo "text: $text"
  [[ -n "$excerpt" && "$excerpt" != "null" ]] && { echo "source_excerpt:"; echo "  $excerpt"; }
  echo

  while true; do
    read -r -p "[a]pprove  [e]dit  [s]kip  [d]rop  [q]uit > " choice </dev/tty
    case "$choice" in
      a|A)
        append_bullet "$text"
        LINES[$i]=$(jq -c --arg s approved '.status=$s' <<<"$line")
        CHANGED=1
        echo "  ✓ approved"
        break
        ;;
      e|E)
        tmp=$(mktemp)
        printf '%s\n' "$text" > "$tmp"
        "${EDITOR:-nano}" "$tmp" </dev/tty
        new_text=$(cat "$tmp"); rm -f "$tmp"
        new_text="${new_text%$'\n'}"
        [[ -z "$new_text" ]] && { echo "  (empty — treating as skip)"; break; }
        append_bullet "$new_text"
        LINES[$i]=$(jq -c --arg s approved --arg t "$new_text" '.status=$s | .text=$t' <<<"$line")
        CHANGED=1
        echo "  ✓ edited & approved"
        break
        ;;
      s|S)
        echo "  … skipped"
        break
        ;;
      d|D)
        LINES[$i]=$(jq -c --arg s dropped '.status=$s' <<<"$line")
        CHANGED=1
        echo "  ✗ dropped"
        break
        ;;
      q|Q)
        echo "quitting"
        # Write back before exit
        printf '%s\n' "${LINES[@]}" > "$QUEUE"
        [[ $CHANGED -eq 1 ]] && "$REBUILD" || true
        exit 0
        ;;
      *) echo "  (pick a/e/s/d/q)";;
    esac
  done
done

printf '%s\n' "${LINES[@]}" > "$QUEUE"
if [[ $CHANGED -eq 1 ]]; then
  "$REBUILD"
  echo "done — bootstrap rebuilt"
else
  echo "done — no changes"
fi
