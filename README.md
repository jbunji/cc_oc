# Claude Code Memory System (OpenClaw-style)

This repo contains a fully working persistent memory + continuity system for Claude Code.

## Features

- Automatic session summaries → `RECENT_WORK.md`
- Durable memory → `MEMORY.md`
- Daily session logs → `daily/`
- Auto bootstrap rebuild on session end
- Hooks-based automation (no manual steps required)

---

## 🚀 Install / Restore

### 1. Clone repo

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO

### 2. Run Script

chmod +x restore_cc_memory.sh
./restore_cc_memory.sh .
