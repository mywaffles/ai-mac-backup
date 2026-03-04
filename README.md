# ai-backup-mac

Git-versioned backup of AI tool configs on the 2026 Mac Mini M4.  
Backs up skills, Claude Desktop config, Claude Code settings, and shell config.  
Every backup is a git commit, pushed to GitHub — full history, safe rollback.

## Commands

```bash
ai-backup              # snapshot everything → git commit → push
ai-restore             # list available backups
ai-restore --last      # restore most recent backup (with confirmation)
ai-restore <hash>      # restore from a specific commit
```

## What Gets Backed Up

Configured in `backup-paths.conf` — edit that file to add or remove paths.

| Repo path | Source |
|---|---|
| `skills/` | `~/.agents/skills/` |
| `files/Claude/` | `~/Library/Application Support/Claude/*.json` |
| `.claude/` | `~/.claude/` |

> **Note:** `~/.zshrc` is intentionally excluded — it contains secrets.  
> Add other paths directly to `backup-paths.conf`.

## On Restore

Before overwriting anything, `ai-restore` renames existing files/dirs with a  
`.bak-YYYYMMDD-HHMMSS` suffix so you can inspect what was broken.

Every backup and restore is logged to `ai-backup.log` (committed to the repo).

## Testing

Run the integration test suite before any checkin:

```bash
bash ~/ai-backup-mac/test-backup.sh
```

The suite (33 tests) creates a test skill, backs it up, corrupts files in each  
category, restores, and verifies both the restored content and the preserved bad files.

## Scripts

Installed to `/opt/homebrew/bin/` — available anywhere in terminal.  
Source lives in `scripts/` in this repo.

## Project

GitHub: [mywaffles/ai-backup-mac](https://github.com/mywaffles/ai-backup-mac)  
Local: `~/ai-backup-mac/`
