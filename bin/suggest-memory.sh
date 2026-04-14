#!/usr/bin/env bash
# suggest-memory.sh — scan a transcript for candidate memory entries,
# append to ~/soul/review/queue.jsonl. Local-only, regex heuristics.
#
# Usage:
#   suggest-memory.sh <transcript.jsonl>
#   suggest-memory.sh --latest               # scan most recent transcript
#   suggest-memory.sh --dry-run <path>       # print candidates, don't write
#
# Dedup: sha1 of normalized text; skipped if hash already in queue.

set -u

QUEUE="/home/parallels/soul/review/queue.jsonl"
mkdir -p "$(dirname "$QUEUE")"
touch "$QUEUE"

DRY=0
TRANSCRIPT=""
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY=1 ;;
    --latest)
      TRANSCRIPT="$(find /home/parallels/.claude/projects -name '*.jsonl' -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | awk '{print $2}')"
      ;;
    -h|--help)
      sed -n '2,10p' "$0"; exit 0 ;;
    *) TRANSCRIPT="$arg" ;;
  esac
done

[ -n "$TRANSCRIPT" ] && [ -r "$TRANSCRIPT" ] || { echo "no readable transcript: $TRANSCRIPT" >&2; exit 1; }

export TRANSCRIPT QUEUE DRY

python3 - <<'PY'
import json, os, re, hashlib, datetime, sys, pathlib

transcript = os.environ["TRANSCRIPT"]
queue_path = os.environ["QUEUE"]
dry = os.environ["DRY"] == "1"

# Load existing hashes
existing = set()
with open(queue_path) as f:
    for line in f:
        line = line.strip()
        if not line: continue
        try:
            existing.add(json.loads(line).get("hash",""))
        except Exception:
            pass

# Extract user messages
users = []
session = ""
with open(transcript) as f:
    for line in f:
        try:
            rec = json.loads(line)
        except Exception:
            continue
        session = session or rec.get("sessionId","") or rec.get("session_id","")
        msg = rec.get("message") or {}
        role = msg.get("role") or rec.get("type")
        if role != "user": continue
        c = msg.get("content", rec.get("content",""))
        if isinstance(c, list):
            c = " ".join(p.get("text","") for p in c if isinstance(p, dict) and p.get("type")=="text")
        if not isinstance(c, str): continue
        c = c.strip()
        # skip tool results / system reminders / hook outputs
        if not c or c.startswith("<") or "tool_use_id" in c[:40]: continue
        users.append(c)

if len(users) < 2:
    print(f"only {len(users)} user prompts — skipping", file=sys.stderr)
    sys.exit(0)

# Heuristics
PAT = [
    ("preference", re.compile(r"^(don'?t|stop|never|always|prefer|from now on|remember to|actually,?)\b", re.I)),
    ("identity",   re.compile(r"^(i'?m a |i am a |my (role|job|title)\b|i work (on|at|in)\b|i use )", re.I)),
    ("project",    re.compile(r"\b(we'?re (building|shipping|migrating|deprecating|working on)|deadline|by (mon|tue|wed|thu|fri|sat|sun)[a-z]*\b|by \d{4}-\d{2}-\d{2})", re.I)),
]

def classify(sentence):
    for t, pat in PAT:
        if pat.search(sentence):
            return t
    return None

def norm(s):
    return re.sub(r"\s+", " ", s.lower()).strip()

candidates = []
for msg in users:
    # split into sentences (rough)
    for sent in re.split(r"(?<=[.!?])\s+|\n+", msg):
        sent = sent.strip()
        if not (20 <= len(sent) <= 400): continue
        t = classify(sent)
        if not t: continue
        h = hashlib.sha1(norm(sent).encode()).hexdigest()
        if h in existing: continue
        existing.add(h)
        candidates.append((t, sent, h))
        if len(candidates) >= 5: break
    if len(candidates) >= 5: break

if not candidates:
    print("no candidates found", file=sys.stderr)
    sys.exit(0)

now = datetime.datetime.now().isoformat(timespec="seconds")
short = (session or "")[:8]

out_lines = []
for t, sent, h in candidates:
    entry = {
        "id": h[:8],
        "ts": now,
        "session": short,
        "type": t,
        "text": sent,
        "excerpt": sent[:200],
        "hash": h,
        "status": "pending",
    }
    out_lines.append(json.dumps(entry, ensure_ascii=False))

if dry:
    print("=== candidates (dry-run) ===")
    for l in out_lines: print(l)
else:
    with open(queue_path, "a") as f:
        for l in out_lines:
            f.write(l + "\n")
    print(f"appended {len(out_lines)} candidate(s) to {queue_path}")
PY
