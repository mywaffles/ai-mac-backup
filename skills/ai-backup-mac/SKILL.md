# ai-backup-mac

Protects the Mac Mini M4 AI config environment by running backups before risky changes and evaluating whether new config files should be added to the backup.

## When to trigger

Run `ai-backup` **before** making changes to any of these:
- `~/.agents/skills/` (any skill file)
- `~/Library/Application Support/Claude/` (any JSON config)
- `~/.claude/` (Claude Code settings, plugins, etc.)
- Any file currently listed in `~/ai-backup-mac/backup-paths.conf`

Also run before:
- Installing, removing, or modifying skills
- Editing MCP server config (`claude_desktop_config.json`)
- Changing Claude Desktop or Claude Code settings
- Any shell session that modifies AI tooling

## How to run a backup

```bash
ai-backup
```

That's it. It reads `~/ai-backup-mac/backup-paths.conf`, syncs all listed paths, commits, and pushes to GitHub.

## How to restore

```bash
ai-restore             # list available backups
ai-restore --last      # restore most recent (with diff preview + confirmation)
ai-restore <hash>      # restore a specific commit
```

Existing files are renamed `.bak-YYYYMMDD-HHMMSS` before being overwritten, so you can always inspect what was broken.

## Evaluating new config files for backup inclusion

When about to make a system-level change, evaluate whether any affected config files are missing from `backup-paths.conf`. Add them if:

1. The file is hand-crafted or non-reproducible (not auto-generated)
2. Breaking it would meaningfully disrupt the AI environment
3. It doesn't contain secrets (API keys, tokens, passwords)

**Common candidates to watch for:**
- New MCP server configs
- Shell profile files (`.zprofile`, `.bash_profile` — not `.zshrc`)
- Tool-specific config dirs (e.g. `~/.config/<toolname>/`)
- New Claude plugin or agent directories

**How to add a new path:**
```bash
echo "~/.config/sometool/config.json" >> ~/ai-backup-mac/backup-paths.conf
ai-backup   # immediately snapshot the new inclusion
```

**Never add:**
- Files containing secrets or tokens (use 1Password instead)
- Auto-generated cache or log files
- Large binary files or node_modules

## Checking what's backed up

```bash
cat ~/ai-backup-mac/backup-paths.conf   # current list
ai-restore                               # see backup history
cat ~/ai-backup-mac/ai-backup.log       # full log of all backups and restores
```

## Testing

Before checking in any changes to backup scripts:

```bash
bash ~/ai-backup-mac/test-backup.sh
```

Must be 33/33 before committing.
