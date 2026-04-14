# Mac Mini Migration Plan
Created: 2026-02-04

## Goal
Move OpenClaw from Pi 5 to Mac Mini under a dedicated standard (non-admin) user account for better performance while maintaining security isolation.

## Pre-Migration Checklist (Kai preps while Justin is out)
- [ ] Document current OpenClaw config from Pi
- [ ] List all SSH keys/access currently in use
- [ ] List all dependencies (Node.js version, npm packages)
- [ ] Plan folder sharing strategy
- [ ] Create step-by-step guide for Justin

## Setup Steps (When Justin is ready)
1. **Create new macOS user**
   - System Settings → Users & Groups → Add User
   - Name: `openclaw` (or `kai`)
   - Type: Standard (NOT admin)
   - Set password

2. **Enable SSH for new user**
   - SSH should already be enabled on the Mac
   - Test login: `ssh openclaw@localhost`

3. **Install Node.js for new user**
   - Use nvm (no sudo needed): `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash`
   - `nvm install 22`

4. **Install OpenClaw**
   - `npm install -g openclaw` (installs to user's nvm prefix, no sudo)
   - Or clone from git

5. **Migrate config & memory**
   - Copy from Pi: `~pi5/clawd/` → new user's home
   - Update config paths as needed
   - Transfer MEMORY.md, memory/, SOUL.md, etc.

6. **Set up SSH keys**
   - Generate new keypair for the openclaw user
   - Add to Windows dev box authorized_keys (ONLY if needed)
   - Pi 5 keeps its own keys as backup

7. **Folder sharing (as needed)**
   - Justin's Projects folder: set ACL for read access
   - `chmod +a "openclaw allow read,readattr,readextattr,readsecurity,list,search" ~/Projects`
   - Only share what's needed

8. **Install extras**
   - Whisper.cpp (for voice transcription)
   - n8n (for automation learning)
   - ffmpeg: `brew install ffmpeg` (may need admin for brew, or use nvm-based alternatives)

9. **Test everything**
   - OpenClaw starts and responds
   - Discord connection works
   - Telegram connection works
   - SSH to Windows dev box works (if key added)
   - Memory files intact

10. **Cutover**
    - Stop OpenClaw on Pi
    - Start on Mac Mini
    - Verify all channels working
    - Keep Pi as backup (can restart if Mac has issues)

## Security Notes
- No sudo on new account
- No access to Justin's home directory by default
- SSH keys only for machines that need access
- Justin controls folder sharing via ACLs
- If compromised: blast radius = only the openclaw user's home + shared folders

## Things to Figure Out
- Does Justin want the user called `openclaw` or `kai`?
- Which folders need sharing? (Projects? specific subdirs only?)
- Do we need brew? (requires admin to install, but Justin can install it under the openclaw user with workarounds)
- Telegram bot token + Discord bot token — same ones, just new config location
- Keep Pi running as fallback or shut it down?
