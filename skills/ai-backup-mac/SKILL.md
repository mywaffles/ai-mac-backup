---
name: ai-backup-mac
description: Protects the Mac Mini M4 AI config environment. Run ai-backup before making any changes to skills, Claude Desktop config, Claude Code settings, or any path in backup-paths.conf. Also evaluates whether new config files encountered during a task should be added to the backup. All commands run on the user's Mac Mini via shell:run_command.
---

# ai-backup-mac

## Always run ai-backup before modifying:
- `~/.agents/skills/`
- `~/Library/Application Support/Claude/`
- `~/.claude/`
- Anything in `~/ai-backup-mac/backup-paths.conf`

```bash
ai-backup
```

## Restore
```bash
ai-restore             # list backups
ai-restore --last      # restore most recent
ai-restore <hash>      # restore exact snapshot at that commit
```

## Adding a new path to backup
If a task touches a config file not in `backup-paths.conf`, add it first if:
- It's hand-crafted (not auto-generated)
- It doesn't contain secrets (use 1Password for those)

```bash
echo "~/.config/sometool/config.json" >> ~/ai-backup-mac/backup-paths.conf
ai-backup
```

## Before checking in changes to backup scripts
```bash
bash ~/ai-backup-mac/test-backup.sh   # must be 33/33
```
