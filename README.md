# ai-mac-backup

Git-versioned backup of AI tools config on Mac Mini M4.  
Run `ai-backup` before risky sessions. Run `ai-restore` to roll back.

## Commands

```bash
ai-backup              # snapshot everything and push to GitHub
ai-restore             # restore from latest backup (with confirmation)
ai-restore --list      # show available backup points
ai-restore <hash>      # restore from specific commit
```

## What Gets Backed Up

| Directory in repo | Source on Mac |
|---|---|
| `skills/` | `~/.agents/skills/` |
| `shell/` | `~/.zshrc`, `~/.zprofile` |
| `claude-desktop/` | `~/Library/Application Support/Claude/*.json` |
| `claude-code/` | `~/.claude/` |

## Scripts

Scripts live in `/opt/homebrew/bin/` — available from anywhere in terminal.

Source: `~/ai-mac-backup/scripts/`
