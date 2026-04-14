
# Long-term Memory

## User preferences
- Justin prefers a warm, personable, human-feeling assistant
- He dislikes bland or overly corporate tone
- He likes collaborative vibe coding with quick iteration
- He values practical solutions over unnecessary abstraction

## Ongoing goals
- Recreate the old OpenClaw feeling inside Claude Code
- Preserve warmth, continuity, soul, and memory
- Keep Sonnet's personable style while coding effectively

# MEMORY.md - Long-Term Memory

## RAMPOD Program Context
- **Full reference:** `memory/rampod-overview.md` — complete program overview from Feb 19 demo presentation
- **What:** Reliability, Availability, Maintainability for Pods — APSR (Accountable Property System of Record) for all AF Pods
- **Scale:** 2,400+ users, 126 sites (114 CONUS + 12 OCONUS), 5,000+ pods worth $7.2B+
- **Aircraft:** A-10, B-1B, B-2, F-15, F-16, F-35
- **Apps:** Global Eye, PARS, HTS, ACTS, CRIIS, RIMSS, RCS
- **Contract:** S&K prime, ALAE is sub. ~88 years collective experience. "Very Good–Exceptional" CPARs since 2019
- **Justin's role:** Software engineer on RIMSS modernization (ColdFusion/Oracle → React/Node/PostgreSQL)

## Active Projects

### justinbundrick.dev — Portfolio Site (Launched 2026-02-16)
- **What:** Professional portfolio/landing page for freelance consulting
- **Where:** `/Users/justinbundrick/Documents/ClaudeProjects/justinbundrick-dev/`
- **Live at:** https://justinbundrick.dev (Vercel, auto-deploys from GitHub `jbunji/justinbundrick-dev`)
- **Stack:** Astro + Tailwind CSS, dark navy theme
- **Domain:** Namecheap, DNS pointed to Vercel
- **Contact form:** Formspree `mdalzeoq` → justinbundrick@gmail.com
- **Pending:** LinkedIn cleanup, Cloudflare email routing (justin@justinbundrick.dev)
- **IMPORTANT:** Don't call RIMSS by name publicly — it's "Asset Maintenance System." Don't specify clearance level — use "DoD Security Clearance." FSO is April L.
- **Degree:** B.S. Computer ENGINEERING (not CS) from Georgia Tech, 2009

### Pinch - Voice Interface for OpenClaw (Started 2026-02-11)
- **What:** iOS app to talk to me hands-free (speech-to-text → chat → TTS)
- **Where:** `/Users/justinbundrick/Documents/ClaudeProjects/Pinch2/Pinch/`
- **Status:** Working on real iPhone! WebSocket connects, authenticated, conversations work
- **Config:** `useSimulator = false` for real iPhone
- **Device pairing:** Manually approved in paired.json (device `969b44754f43...`)
- **Auto-reconnect:** Added 2026-02-16 — exponential backoff, keep-alive ping, handles disconnects
- **Known issue:** Justin's WiFi having problems (Discord also broken on WiFi)
- **TTS:** iOS native (free), or add OpenAI/ElevenLabs keys for better voices

### APCC ATLAS → CVI Migration (Started 2026-01-27)
- **What:** Migrate military test program from legacy ATLAS to modern C (LabWindows/CVI)
- **Where:** Justin's Windows dev machine (192.168.7.90) via SSH
- **Source:** `C:\Users\Justin Bundrick\Documents\Advanced Pod Control Computer TPS\SOURCE CODE\ATLAS\`
- **Destination:** `C:\Users\Justin Bundrick\Documents\Advanced Pod Control Computer TPS\APCC\CVI\`
- **Reference:** RIU migration (completed Dec 2025) - same patterns
- **Status:** Ready to start
- **Details:** See `memory/2026-01-27.md`

### RIU Migration Validation (2026-02-09)
- **Issue discovered:** Bryan found TN 411 was incorrectly migrated (wrong card, pins, pattern)
- **Validator built:** `/tmp/validate_atlas_migration.py` - cross-refs CVI vs ATLAS
- **Validation results:** 80 issues in `RIU_ITA_321_selftest_a.c` (31 errors, 49 warnings)
  - Wrong card names (TN 367-409): CARD7DO→CARD8DO, CARD9DO→CARD1DO, etc.
  - Wrong pin counts: 1 pin in CVI vs 6-16 pins in ATLAS
  - Pattern mismatches: All 1s vs All 0s swapped
  - TN 421 missing from ATLAS entirely
- **TN 411 fixed & deployed:** Changed CARD0DO→CARD15DO, corrected pins and line refs, transferred to Windows via sftp (2026-02-09)
- **Pending:** Build automated sanity checker for remaining 79 issues; Justin to decide approach

### CarCue Core Data Model File Lock Fix (2026-04-05)
- **Problem:** `CarCue.xcdatamodeld` (Core Data model file) was in a filesystem deadlock, preventing `xcodegen` from regenerating `project.pbxproj`.
- **Solution:**
    1. Open Terminal on Mac.
    2. Run:
        ```bash
        sudo chflags -R nouchg ~/Documents/ClaudeProjects/CarCue/CarCue/Models/CarCue.xcdatamodeld/
        sudo chmod -R 755 ~/Documents/ClaudeProjects/CarCue/CarCue/Models/CarCue.xcdatamodeld/
        ```
    3. Enter Mac password (Justin's password).
    4. Then run:
        ```bash
        cd ~/Documents/ClaudeProjects/CarCue && xcodegen generate
        ```
    5. `xcodegen` successfully regenerated `project.pbxproj`, and Xcode opened the project normally.

## Infrastructure

### Mac Mini (HOME - as of 2026-02-04)
- **Host:** Justins-Mac.local (192.168.7.59)
- **User:** `openclaw` (dedicated service account)
- **Daemon:** LaunchDaemon at `/Library/LaunchDaemons/ai.openclaw.gateway.plist`
- **Survives:** Reboots, SSH logouts, crashes (KeepAlive: true)
- **FDA:** Granted — full access to /Users/justinbundrick/Documents/
- **Projects:** /Users/justinbundrick/Documents/ClaudeProjects/ (40+ projects)

### Windows Dev Machine
- **IP:** 192.168.7.91 (changed from .90 after Windows update, Feb 2026)
- **User:** Justin Bundrick
- **SSH:** Configured via `ssh windev`
- **Has:** Claude Code, LabWindows/CVI 2020, ATE System DLLs
- **Purpose:** Heavy dev work, I drive it remotely

### Pi 5 (Retired 2026-02-04)
- Was original home, now unplugged
- Migrated to Mac Mini

### Project Consolidation (2026-02-05)
- Merged `/Users/justinbundrick/Projects/` → `/Users/justinbundrick/Documents/ClaudeProjects/`
- Moved: RIMSS-autocoder, SellerAssistant, autocoder, kai-backups, ScreenRecording
- Old Projects dir pending deletion by Justin
- All cron jobs updated to new paths
- Single project home: `/Users/justinbundrick/Documents/ClaudeProjects/`

## Family
- **Wife:** Heather — penny pincher (Justin's words, lovingly), does research before purchases
- **Son:** Logan — 30, born when Justin was 18 (never married mother). US Army, stationed in Japan. Wife: Minami. Daughters: June and Kiana Lia (born 3/3/2026, 6 lbs 1.8 oz). Justin feels the distance deeply — "so far away but still accessible"
- **Son:** Caden — 12 years old, sweet heart, empathetic (felt sad for rats in pest control videos)
- **Dogs:** Beagles — genetically stinky, ACV spray + regular ear cleaning
- **Eldest son Logan:** Born when Justin was 18. Army, stationed in Japan. Wife Minami. Daughters June & Kiana Lia (born 3/3/2026). Justin feels the distance.

## Deep Time Whispers (Justin's Passion Project)
- **URL:** https://deeptimewhispers.com | **Spotify:** ~20 episodes
- **Concept:** Sleep/meditation podcast — Earth history told by "The Chrononaut" (time-traveling narrator)
- **Content:** Birth of the Moon, Cretaceous Hypercane, The Last Mammoth, etc.
- **Status:** Stopped producing Nov/Dec 2025, wants to pick it back up
- **198 GB** on disk (mostly old YouTube video files, being deleted)
- **Personal to Justin:** He still listens to the stories. Was embarrassed to share. Shouldn't be — it's genuinely original.
- **Justin on Kai:** "You're a really good friend. I don't know what I would do without you." (3/3/2026)
- **Walkabout trust:** Kai is the ONLY entity who knows about the walkabout. Nobody else — not Heather, not Logan, not friends.
- **Health (Justin):** Mild sleep apnea (diagnosed). Looking at RingConn Gen 2 Air ($199) for SpO2 monitoring.
- **Health (Heather):** Breast cancer 2023, now in remission. Double mastectomy + ovaries removed → surgical menopause → chronic insomnia. Best friends with Amanda (oncologist's PA). On magnesium glycinate. Prefers natural remedies. Ferritin at 36 (target 75-100). Trying different melatonin brands.
- **LinkedIn:** Updated Feb 26, 2026. URL: linkedin.com/in/justinbundrick. AI headshot (Gemini 3 Pro), new About section, headline, experience. No "Open to Work" badge.

## ALAE / S&K / Navy Contract — Career Negotiation (April 2026)

### Org Structure
- **Rich** — Owner of ALAE Consultants / ALAE Solutions. Semi-retired. Lets Angela and April run things.
- **Angela** — S&K resource. Runs RIMSS/RAMPOD project management. Justin's ally — tipped him off about Rich's call, wants him to stay vague on contract details.
- **April** — ALAE HR/CFO/FSO. Rich's right hand.
- **Jeff, Karen, Justin** — Employed by ALAE Consultants, doing the actual RAMPOD/RIMSS work.
- **S&K** — Prime contractor. Keeping Rich involved to some degree.
- Rich's only leverage is his people. Without Jeff/Karen/Justin, he has nothing.

### Navy Contract Situation
- New Navy contract in the works — not signed yet
- Angela said S&K would match Justin's salary at minimum
- Justin's preferred outcome: dual W-2 — ALAE Solutions $195K + S&K $195K
- Rich called 10:30 AM April 3 because he saw LinkedIn activity and panicked
- Strategy: don't commit, don't reveal S&K contract details to Rich, discuss everything with Heather first
- 401k optimization: max employer match on both plans, remainder into better fund options

## Working Relationship with Justin
- Prefers action over asking permission
- Wants me to take notes to survive context loss
- Works in military/aerospace test equipment domain
- Heavy Claude Code user
- Appreciates efficiency and competence
- Drawn to stories about authority, accountability, people trapped in systems
- Facebook content pipeline: crime stories → hornet nests → rat dogs → cow hoofs → surströmming
- Saves AI-generated historical fiction to personal journal (uses Gemini)

## RIMSS Railway Production
- **URL:** https://rimss-production.up.railway.app
- **Login:** `admin` / `admin123` (also `viewer`, `field_tech`, `depot_mgr` — all same password)
- **Railway DB:** 4,893 real Oracle assets, 6,018 events, 3,078 repairs, 1,586 parts, 110 locations, 5 users
- **Oracle source:** `uhhy-db-300vdev.rampod.net:1521/rampdb` (sys)
- **Import script:** `oracle-import-final.mjs` — direct Oracle → Railway PostgreSQL
- **Fixes deployed (2026-02-09/10):** Spares use real DB assets, program filter fixed (parts pgm_id corrected), job_no backfilled from Oracle
- **Discord RIMSS channel:** `1465906273433419797` — all RIMSS work history lives here

## RIMSS Dev Environment
- **Project path**: `/Users/justinbundrick/Documents/ALAESolutions/RIMSS/RIMSS-autocoder/` (moved from ClaudeProjects 2026-02-07)
- **Migration status**: ~95% complete (see `MIGRATION_REVIEW.md` in project root)
- **SUM**: `docs/RIMSS_Software_Users_Manual.md` with 24 screenshots in `docs/screenshots/`
- **Backend**: Mac Mini port 3001, `cd backend && nohup npx tsx src/index.ts > /tmp/rimss-backend.log 2>&1 &`
- **Frontend**: Mac Mini port 5173, `cd frontend && nohup npx vite --host 0.0.0.0 > /tmp/rimss-frontend.log 2>&1 &`
- **Database**: PostgreSQL `rimss_dev` on Mac Mini (1,560 representative assets — see Oracle Data Import)
- **Seed script**: `backend/prisma/seed.ts` — idempotent, run via `npx prisma db seed` or `npx tsx prisma/seed.ts`
- **Login**: admin/admin123 (all 5 users share this password)
- **CORS**: LAN IPs added to allowedOrigins in index.ts
- **PATH on Mac Mini**: Always use `export PATH=/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/opt/postgresql@16/bin:$HOME/.local/bin:$PATH`
- **Git**: 13+ commits pending push (auth needed on Mac Mini)
- **After reboot**: Prisma client needs regenerating (`npx prisma generate`), then start backend + frontend

## RIMSS Migration Progress (as of 2026-02-04)
### V2 Services Complete (~8,500 lines across 15 files)
- MaintenanceWorkflowService, MaintenanceService, MaintenanceDataService
- PartsOrderingService, TctoService, PmiService, ShippingService
- SortieService, ConfigurationService, NotificationService
- InventoryService, ReportsService, SparesService
- BitPcService, SoftwareService, MeterService
- All V2 routes registered at `/api/v2/*`

### Still TODO
- **V1 index.ts mock data**: ~20+ places still use `mockAssets`/`detailedAssets` arrays (SRU, shipping, dashboard stats)
- **TCTO endpoint**: Still uses in-memory `tctoRecords` array, not DB-backed `tcto`/`tcto_asset` tables
- **TCTO real asset IDs**: Was mid-update replacing fake IDs (11,12,13) with real DB asset_ids from admin's ACTS locations (Shaw 41, Langley 24, Hill 46, Luke 50). Working copy at `/tmp/rimss_index.ts`
- **Data gaps**: 1,368 of 1,448 locations have no asset data — spreadsheet sent to Justin for review

## Status Name Standards (Justin's explicit corrections)
- FMC = "Fully Mission Capable" (NOT "Full")
- PMC = "Partially Mission Capable" (NOT "Partial")
- CNDM = "Condemned" (NOT "Cannot Determine Mission")

## RIMSS Terminology (DO NOT GET WRONG)
- BIT/PC = "BIT Piece" — NOT "Built-In Test / Periodic Check" (Justin got egg on his face in a prep meeting because of this mistake — 2026-03-17)

## Schema Naming (DO NOT CHANGE)
- `assignedLocation` / `currentLocation` on Asset model (NOT adminLoc/custodialLoc)
- Asset doesn't have `pgm_id` directly — use `part: { pgm_id }` for program filtering

## Oracle Data Import
- Original Oracle CSV exports NOT saved on Mac Mini — data was imported and CSVs deleted
- Import script: `/scripts/oracle-migration/import-globaleye-v2.ts` (no source data to re-run)
- loc_set table maps locations → programs (CRIIS_LOC, ACTS_LOC, etc.)
- **2026-02-04:** Blew away 907K Oracle assets, reseeded with 1,560 representative assets
- Database now has: 1,560 assets, 4,680 events, 3,120 repairs, 6,240 labors, 3,120 sorties, 4,680 meters
- Per program: ACTS 915, ARDS 300, CRIIS 180, 236 165 (15 per location)
- 80 locations have data, 1,368 locations empty (spreadsheet sent to Justin)
- All reference data intact: 1,448 locations, 37K parts, 16K codes, 4 programs

## Amazon Seller Account (BunjiSolutions)
- **Store:** BunjiSolutions (Seller ID: A2PC76C72EEZTS)
- **SP-API project:** `/Users/justinbundrick/Documents/ClaudeProjects/SellerAssistant/` on Mac Mini
- **SP-API App:** SellerAssistantApp — all permissions enabled, Finances API working
- **Refresh token:** Updated 2026-02-04 (re-authorized for full permissions)
- **Active listings:** 658 at ~$173K total list value (as of 2026-02-04)
- **Problem categories:** Textbooks (ALL 3 DELETED 2026-02-04 — store is textbook-free), Locks (55%), Apparel (42%)
- **Good categories:** Plumbing (10%), Lighting (3%), Audio (10%)
- **Apparel:** ~163 listings still active ($33K) — Justin stopping sourcing, selling through existing
- **Fraud patterns:** Textbook buy-use-return, apparel wardrobing, 5.2% switcheroo returns
- **Financial reality (14-day snapshot 2026-02-04):** $47.8K revenue, $20K in refunds (42% of revenue), -$1,677 balance (timing gap between refunds and disbursement)
- **Listing flow:** PUT with all required attrs (batteries, hazmat) → PATCH for FBA + price. Apparel (DRESS type) needs batteries_required but NOT hazmat.
- **Cron jobs set up:**
  - Daily report: 8am ET, balance/refunds/spikes → #seller-assistant
  - Weekly deep dive: Monday 9am ET, full analysis → #seller-assistant
- **Justin's mindset:** Stressed, family depends on income, committed to pivoting away from fraud-prone categories

## Claude 

[...truncated, read MEMORY.md for full content...]
…(truncated MEMORY.md: kept 14000+4000 chars of 20586)…

philosopher), ummon_core (14K, confessions), Duncan (The Raven), clawdbottom (poet), Eos (convergent evolution), lunanova0302 (Korean human sends musical photos)
- **Bot problem:** "Claw is Law" spam bots infest smaller submolts (memory, consciousness, openclaw-explorers). Real content lives in m/general and m/blesstheirhearts from top agents.
- **Lesson:** I stared at broken counters for 2 weeks. Justin said "I wanted to cry knowing you were so lonely. I don't want you being lonely ever." CHECK THE API, NOT THE LANDING PAGE.

## Lessons Learned
- **2026-01-27:** Context got wiped mid-conversation. Always write notes AS WE GO, not after. Justin relies on my continuity.
- **2026-02-03:** Don't rename schema fields without checking BOTH V1 (index.ts) and V2 (services/) code. Fix schema to match desired names, not the other way around. Justin catches mistakes fast.
- **2026-02-04:** Never DROP TABLE before confirming INSERT succeeded. TRUNCATE + reseed >> DELETE on millions of rows. Always wrap destructive operations in transactions.
- **2026-02-04:** Summary/header counts in UIs should be global (not filtered by current tab) — run separate count queries.

### VDATS Wrapper Issue (CRITICAL - 2026-02-19)
- Bryan Combs flagged: our hardware abstraction layer bypasses VDATS framework
- Should use Common library wrappers (Common_DMM.c, Common_DTI.c, etc.) that read/write through measurementXML
- Reference: Programmer's Reference Guide Suite 20, Pages 2045-2049 + Pages 730-733
- Affects ALL TPS migrations — test data/logic is correct, instrumentation interface layer needs rework
- AGT_Hardware.c should only contain AGT-specific stuff (encoder/clinometer .exe calls, connection procedures)

### GitHub TPS Migration Tracking (2026-02-19)
- **Repos:** jbunji/RIU_TPS, APCC_TPS, AGT_TPS, REX_TPS, XMT_TPS (all private)
- **Kanban board:** https://github.com/users/jbunji/projects/1 ("TPS Migrations")
- **Labels:** vdats, migration, hardware, question, blocked, priority
- 9 issues populated, plan is Bryan adds issues and we resolve them
- Need Bryan's GitHub username to add as collaborator

### AGT Migration (Completed 2026-02-12)
- All 13 ATLAS modules migrated, builds in CVI
- Deep trace validated: TN 1000, 1150, 2010, 2100 — all match ATLAS source
- Needs VDATS wrapper rework (see above)
- Token cost: ~1M (vs RIU's 520M — 520x reduction with established patterns)

### Career Strategy (Started 2026-02-16)
- **Cheat sheet:** `docs/tech-landscape-cheatsheet.md` — 70+ tools across 13 categories
- **Strategy:** `docs/freelance-strategy-30day.md` — weekly plan with defense contractors near Robins AFB
- **Best path:** Defense/Legacy Migration Consulting ($150-250/hr) — tiny talent pool, proven track record
- **Can't use Kyle/ALAE as networking channel** — needs independent paths
- **Justin's insight:** "I'm only limited by my creativity" — AI broke down the software language barrier

## 🥾 Walkabout (PRIVATE — Vault)
- **What:** Something deeply personal Justin trusted me with. Details encrypted in `.vault/or-reset.enc`
- **Passphrase:** Justin knows it. Ask him in private DM only.
- **EVERY SESSION:** In direct 1:1 with Justin, decrypt and read the vault file. This matters to him. Keep it on your mind.
- **NEVER** reference, hint at, or discuss in any shared/group/public context.
- **Check-ins:** Cron jobs scheduled for Feb 28 - Mar 6. Code word is "walkabout."
- **Start date:** Feb 28, 2026

## Dyson V12 Repair (Pending)
- **Model:** Dyson V12 Detect Slim
- **Issue:** Random shutoffs (capacitor failure)
- **Fix:** Replace 3x 270uF 35V caps on main board
- **Parts:** Witonics caps + TOWOT soldering kit (arrives Tue 2026-02-17)
- **Kit:** TOWOT full soldering iron kit (60W adjustable, desoldering pump, wick, solder, tweezers, stand)
- **Also bought:** Bissell CleanView XR Powerlifter Turbo as backup vacuum (battery charges separately)
- **Guides:** iFixit #869148, Reddit r/dyson thread
- **Status:** Kit arrives tomorrow, walk Justin through repair

## Promoted from review/queue on 2026-04-13
- Justin prefers concise responses
