# Rules for Claude — ai-backup-mac

## Before modifying AI config files

**Always run `ai-backup` before making changes to:**
- `~/.agents/skills/` — any skill file
- `~/Library/Application Support/Claude/` — any JSON config
- `~/.claude/` — Claude Code settings, plugins
- Any path in `~/ai-backup-mac/backup-paths.conf`

No exceptions. Run it even if you ran it recently. It no-ops if nothing changed.

## Evaluating new config files

When a task touches a config file not currently in `backup-paths.conf`, evaluate whether it should be added:
- Is it hand-crafted or non-reproducible?
- Would breaking it disrupt the AI environment?
- Does it contain secrets? (If yes: do NOT add it — use 1Password instead)

If yes, add it to `backup-paths.conf` and run `ai-backup` before proceeding.

## Before checking in changes to this repo

Run the test suite and confirm 33/33:

```bash
bash ~/ai-backup-mac/test-backup.sh
```
