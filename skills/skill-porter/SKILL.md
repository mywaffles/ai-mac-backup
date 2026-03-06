---
name: skill-porter
description: >
  Automatically ports Claude Code skills to Claude Chat. Use this skill EVERY TIME
  a new skill is installed or discovered via Claude Code (npx skills add, npx skills
  find, or manual creation in ~/.agents/skills/ or ~/.claude/skills/). Also use when
  the user asks to "port skills", "sync skills", "update Chat skills", or mentions
  skills being out of sync between Code and Chat. This skill should trigger
  proactively — whenever a skill is installed in Claude Code, immediately offer to
  port it to Chat without being asked.
  IMPORTANT: Claude Chat CANNOT install skills via filesystem copy to ~/.claude/skills/.
  The ONLY method that works is packaging a .skill zip via bash_tool in the sandbox
  and presenting it with present_files. Do NOT skip this skill and improvise.
---

# Skill Porter: Claude Code → Claude Chat

> **STOP: Do not copy files to ~/.claude/skills/ and call it done.**
> Claude Chat installs skills ONLY via the .skill zip + present_files flow described below.
> Filesystem copies to the Mac Mini are invisible to Claude Chat.

## Purpose

Automatically port skills from Claude Code to Claude Chat whenever new skills are installed, discovered, or created. The user should never have to manually request this — it should happen as part of the skill installation workflow.

## When to Use

- **After installing a skill via `npx skills add`** — immediately port it
- **After creating a new skill** in `~/.agents/skills/` or `~/.claude/skills/`
- **When the user asks** to sync, port, or compare Code vs Chat skills
- **When listing skills** and a mismatch is detected between Code and Chat

## Porting Workflow

### Step 1: Read the Claude Code skill

Use `shell:run_command` to read the skill from the Mac Mini:

```
shell:run_command: cat ~/.agents/skills/<skill-name>/SKILL.md
```

Also check for reference files and scripts:

```
shell:run_command: find ~/.agents/skills/<skill-name> -type f
```

Note: Skills may also live in `~/.claude/skills/`. Check both locations.

### Step 2: Adapt for Claude Chat

Make these modifications to the SKILL.md:

1. **Remove `allowed-tools:`** from YAML frontmatter (Claude Code-specific)
2. **Update the description** to include "All commands run on the user's Mac Mini via shell:run_command." if the skill involves shell commands
3. **Do NOT change** the core content, reference files, or scripts — they work the same way since Claude Chat executes commands via `shell:run_command` on the same Mac Mini

### Step 3: Package as .skill file

Create a zip archive with the correct structure:

```bash
# In the sandbox environment (bash_tool, not shell:run_command):
# 1. Create temp directory matching skill name
mkdir -p /tmp/<skill-name>/references  # if references exist

# 2. Copy adapted SKILL.md
# 3. Copy all reference files and scripts

# 4. Package as .skill (which is just a zip)
cd /tmp && zip -r /mnt/user-data/outputs/<skill-name>.skill <skill-name>/
```

IMPORTANT: The .skill file must be created in the sandbox (`bash_tool`) and placed in `/mnt/user-data/outputs/` so the user gets an install button. The file cannot be created on the Mac Mini because the sandbox and Mac Mini have separate filesystems.

### Step 4: Present to user

Use `present_files` to share the .skill file. The user will see an install button and can one-click install it into their Claude Chat project.

```
present_files: ["/mnt/user-data/outputs/<skill-name>.skill"]
```

## Handling Large Skills with Reference Files

For skills with reference files (like automating-mac-apps), the content must be transferred from the Mac Mini to the sandbox. Since the filesystems are separate:

1. For small files: read via `shell:run_command`, write via `create_file` in sandbox
2. For large skills: use `shell:run_command` to create the zip on the Mac Mini, then base64 encode and transfer, OR copy to Mac Mini Desktop as a fallback the user can drag-drop

## Batch Porting

When asked to sync all skills, compare these two lists:

**Claude Code skills:**
```
shell:run_command: ls ~/.agents/skills/ ~/.claude/skills/ 2>/dev/null
```

**Claude Chat skills:**
Check the available_skills list in the current session, or:
```
ls /mnt/skills/user/
```

Port any skills present in Code but missing from Chat.

## Skills That Should NOT Be Ported

Some Claude Code skills don't make sense in Chat:

- **bash-loop** — behavioral mode for Claude Code's tight action loop, not applicable to Chat
- **bash-defensive-patterns** — general reference, limited value in Chat context
- Skills that depend on Claude Code-specific tools or workflows with no Chat equivalent

When encountering these, explain why they're not being ported rather than silently skipping them.

## Post-Install Reminder

After the user installs the .skill file, remind them: "Start a new conversation for the skill to appear in the active skills list."
