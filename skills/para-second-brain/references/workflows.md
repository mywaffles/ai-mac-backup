# PARA Workflows

## Vault Location

```
VAULT="/Users/mattabar/Library/CloudStorage/GoogleDrive-mattaabar@gmail.com/My Drive/Obsidian/2brain"
```

## 1) Weekly Inbox Processing

Time estimate: 15 minutes for ~20 items.

Steps:
1. Open `00_INBOX` and process items one by one.
2. Apply the three questions (Project, Area, Resource).
3. Move item to the first matching destination.
4. If no destination exists, decide whether to create a new folder (only if recurring and meaningful).
5. Empty inbox to zero.

Walkthrough:
- Item: "Vendor quotes for office move" -> Active project `Office Move July`.
- Item: "Manager coaching notes template" -> Area `People Management`.
- Item: "Article: Async communication patterns" -> Resource `Communication`.

## 2) Monthly Review

Time estimate: 30-60 minutes.

Steps:
1. Review all `10_PROJECTS/Active` projects for status and relevance.
2. Flag projects with no activity in 30+ days (check `Log.md` for last activity).
3. Decide for each stale project: archive, activate, or delete.
4. Review Areas for standard drift and needed updates.
5. Move completed projects to archive and capture outcomes.
6. Verify all active projects have a parent link in `To Do (PARA).md` (see Project Links below).

Walkthrough:
- `Website Migration` inactive 42 days, status marked complete -> archive.
- `Hiring Backend` inactive 35 days, still needed -> activate with next actions.

## 3) New Project Setup

Time estimate: 10 minutes.

Template structure (all markdown files):
- `AGENTS.md` - project outcome, timeline, ownership, and operating guidance
- `Tasks.md` - executable task list
- `Notes.md` - working notes, decisions, and references
- `Log.md` - timestamped activity log

Steps:
1. Create project folder in `10_PROJECTS/Active/`.
2. Add `AGENTS.md`, `Tasks.md`, and `Notes.md`.
3. Define desired outcome and due date/timeline in `AGENTS.md`.
4. Add first action items to `Tasks.md`.
5. Add initial entry to `Log.md`.
6. **Add a parent link in `To Do (PARA).md`** under the appropriate category (see Project Links below).

Walkthrough:
- Project: `Q2 Webinar Launch`
- Create files, define outcome (launch by May 30), add kickoff tasks.
- Add to `To Do (PARA).md`: `- [ ] [[10_PROJECTS/Active/Q2-Webinar-Launch/Tasks|Q2 Webinar Launch]] 📅 2026-05-30`

## 4) Project Completion and Close-Out

Time estimate: 10-15 minutes.

Required completion summary fields:
- Outcome
- What worked
- What didn't
- Reusable assets

Steps:
1. Confirm deliverable is complete.
2. Create completion summary using the required fields.
3. Extract reusable assets to Resources if applicable.
4. Add final entry to `Log.md`.
5. Mark project complete (update AGENTS.md frontmatter).
6. Move project folder from `10_PROJECTS/Active/` to `40_ARCHIVE/Projects/`.
6. **Remove or check off the parent link in `To Do (PARA).md`.**

Walkthrough:
- Project: `Customer Onboarding Rewrite`
- Outcome: onboarding completion rate improved 11%.
- Reusable assets: onboarding checklist and interview guide moved to Resources.
- Mark done in `To Do (PARA).md`: `- [x] [[40_ARCHIVE/Projects/Customer-Onboarding-Rewrite/Tasks|Customer Onboarding Rewrite]] ✅ 2026-03-04`

## 5) Archiving

Time estimate: 5-10 minutes per project.

Steps:
1. Verify project is complete or intentionally retired.
2. Ensure completion summary exists.
3. Move project folder to `40_ARCHIVE/Projects/`.
4. Preserve original file structure.
5. Add archive date in project metadata.
6. **Update or remove the parent link in `To Do (PARA).md`.**

Walkthrough:
- `Q1 Planning` moved to archive after retrospective and summary capture.
- Parent link in `To Do (PARA).md` marked complete or removed.


## AGENTS.md Frontmatter (Required)

Every project's `AGENTS.md` MUST have YAML frontmatter for Dataview queries to work.
The `Projects.md` dashboard in the vault root auto-generates from this data.

```yaml
---
status: Active           # Active | Paused | Complete | Cancelled
summary: "One-line description"
started: YYYY-MM-DD
due: YYYY-MM-DD
completed:               # Fill when done: YYYY-MM-DD
---
```

Templates live in `10_PROJECTS/_Templates/`. Always copy from there when creating projects.

---


## Log.md (Activity Log)

Every project has a `Log.md` file — a timestamped record of work done on the project.

### Format

```markdown
# Log

## 2026-03-04 14:30
- Created project, defined research questions
- Added initial tasks

## 2026-03-05 09:15
- Completed sailboat broker comparison
- Updated Research.md with findings
```

### Rules

- **Every time work is done on a project**, append a new timestamped entry to `Log.md`
- Entries are reverse-chronological (newest first, below the `# Log` header)
- Include what was done, decisions made, and any blockers
- Monthly review uses `Log.md` to detect stale projects (no entries in 30+ days)
- Keep it brief — this is a changelog, not a journal

## Project Links in To Do (PARA).md

`To Do (PARA).md` is the **single hub** for all actionable work. Every active project
MUST have a parent link in this file so Matt can navigate to all task lists from one place.

### Format

Under the appropriate category header in `To Do (PARA).md`, add:

```markdown
- [ ] [[10_PROJECTS/Active/project-name/Tasks|Project Display Name]] 📅 YYYY-MM-DD
```

This creates a clickable wikilink in Obsidian that goes straight to the project's task list.

### Rules

- **Creating a project** → add parent link to `To Do (PARA).md` (use `personal-todos` skill to write the file)
- **Archiving a project** → mark the link `- [x]` with completion date, or remove it
- **Monthly review** → verify every active project has a parent link
- The link target should be the project's `Tasks.md` file (pipe alias for display name)
- Place under the most relevant category header (Travel, Tech, etc.)

---

## Research Workflow Rules

When doing research related to any project:

1. **Always check existing research first** — search `30_RESOURCES/`, `40_ARCHIVE/Projects/`, and the vault broadly before starting new research
2. **Update PARA files after every research session** — new findings go into the project's `Research.md`, sources into `_Sources/`, and a log entry into `Log.md`
3. **Extract durable knowledge** — when research is complete, move reusable findings to `30_RESOURCES/` so they're discoverable outside the project
