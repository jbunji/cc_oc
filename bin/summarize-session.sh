#!/usr/bin/env bash
# Append a structured, mechanical summary of a session to RECENT_WORK.md.
# Called by the SessionEnd hook (append-session-note.sh) AFTER the daily note
# is written. Append-only; never rewrites existing entries.
#
# Inputs (env vars, all optional):
#   TRANSCRIPT       path to session transcript JSONL
#   CWD              working directory of the session
#   REASON           SessionEnd reason (clear, logout, prompt_input_exit, ...)
#   SESSION_ID       full session id (short form derived here)
#   PROMPTS          prompt count (already computed)
#   TOOLS            tool call count (already computed)
#   TOOL_BREAKDOWN   "Bash:6, Edit:1, ..." (already computed)
#   LAST_ASK         last user message, trimmed
#
# Disable with: SOUL_AUTO_SUMMARY=0
#
# Never blocks: any failure path exits 0.

set -u
trap 'exit 0' ERR

[ "${SOUL_AUTO_SUMMARY:-1}" = "0" ] && exit 0

RECENT="/home/parallels/soul/RECENT_WORK.md"
touch "$RECENT" 2>/dev/null || exit 0

# Skip noise sessions
if [ "${PROMPTS:-0}" -lt 1 ]; then
  exit 0
fi

SHORT_ID="${SESSION_ID:0:8}"
[ -z "${CWD:-}" ] && CWD="unknown"
[ -z "${REASON:-}" ] && REASON="unknown"

HAVE_JQ=0
command -v jq >/dev/null 2>&1 && HAVE_JQ=1

KEY_ASKS=""
FILES_TOUCHED=""
URLS=""

if [ "$HAVE_JQ" = "1" ] && [ -n "${TRANSCRIPT:-}" ] && [ -r "${TRANSCRIPT:-}" ]; then
  # Up to 5 user asks, first 120 chars each
  KEY_ASKS=$(jq -rs '
    [.[] | select(.type=="user" or (.type=="message" and .message.role=="user"))
         | .message.content
         | if type=="string" then . else ([.[]? | select(.type=="text") | .text] | join(" ")) end
         | select(. != null and . != "")]
    | .[0:5][]
  ' "$TRANSCRIPT" 2>/dev/null \
    | awk 'NF{gsub(/\r/,""); gsub(/\n/," "); s=substr($0,1,120); print "  - " s}' \
    | head -n 5)

  # Files touched via Edit/Write/NotebookEdit
  FILES_TOUCHED=$(jq -rs '
    [.[] | select(.type=="assistant" or (.type=="message" and .message.role=="assistant"))
         | .message.content[]?
         | select(.type=="tool_use")
         | select(.name=="Edit" or .name=="Write" or .name=="NotebookEdit")
         | .input.file_path // empty]
    | unique | .[]
  ' "$TRANSCRIPT" 2>/dev/null \
    | awk 'NF{print "  - " $0}' \
    | head -n 20)

  # URLs from any text blocks (user or assistant)
  URLS=$(jq -rs '
    [.[] | .message?.content? // empty
         | if type=="string" then .
           elif type=="array" then ([.[]? | (.text? // .input? // empty) | tostring] | join(" "))
           else empty end]
    | join(" ")
  ' "$TRANSCRIPT" 2>/dev/null \
    | grep -oE 'https?://[A-Za-z0-9._~:/?#@!$&'"'"'()*+,;=%-]+' \
    | sort -u \
    | head -n 10 \
    | awk '{print "  - " $0}')
fi

TS="$(date '+%Y-%m-%d %H:%M')"

{
  echo
  echo "## $TS — ${SHORT_ID:-nosession} — cwd: $CWD"
  echo "- reason: $REASON"
  echo "- prompts: ${PROMPTS:-0}   tools: ${TOOLS:-0}${TOOL_BREAKDOWN:+ ($TOOL_BREAKDOWN)}"
  if [ -n "$KEY_ASKS" ]; then
    echo "- key asks:"
    printf '%s\n' "$KEY_ASKS"
  fi
  if [ -n "$FILES_TOUCHED" ]; then
    echo "- files touched:"
    printf '%s\n' "$FILES_TOUCHED"
  fi
  if [ -n "$URLS" ]; then
    echo "- urls/artifacts:"
    printf '%s\n' "$URLS"
  fi
  if [ -n "${LAST_ASK:-}" ]; then
    echo "- open thread / last ask: \"$LAST_ASK\""
  fi
} >> "$RECENT" 2>/dev/null || exit 0

exit 0
