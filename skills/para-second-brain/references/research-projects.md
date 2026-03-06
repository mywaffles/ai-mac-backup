# Research Projects in PARA

## Mandatory Structure

All research projects MUST use this template from `10_PROJECTS/_Templates/Research Project Template/`

### Required Files

```
10_PROJECTS/Active/[Project Name]/
├── AGENTS.md          ← Objective, timeline, research questions
├── Tasks.md           ← Checklist (setup → research → analysis → complete)
├── Research.md        ← Synthesis document (findings + comparison)
├── Decision.md        ← Final decision + lessons learned
├── _Sources/          ← Raw materials (PDFs, links, snapshots)
│   └── README.md
└── _Notes/            ← Literature notes (one per source)
    └── README.md
```

## Workflow Enforcement

**Before starting any research:**
1. Check `30_RESOURCES/` and `40_ARCHIVE/Projects/` for existing research on the topic
2. Search the vault for related notes
3. Read any existing findings before duplicating work

**When creating a research project:**
1. Copy entire `_Templates/Research Project Template/` folder
2. Rename to project name
3. Move to `10_PROJECTS/Active/`
4. Fill in AGENTS.md immediately

**When conducting research:**
1. Add each source to `_Sources/` as you find it
2. Create literature note in `_Notes/` for each source
3. **Update Research.md immediately** with new findings
4. **Update TODO.md immediately** when findings resolve open tasks
5. **Mark TODOs complete** as soon as you confirm they're done
6. Keep synthesis current - don't save it all for the end

**Real-time sync rule:** The moment you discover an answer (notification sent, item purchased, decision made), update both Research.md AND TODO.md before continuing to the next task.

**During research:**
1. Append a timestamped entry to `Log.md` every time work is done
2. Update `Tasks.md` as steps are completed

**When completing research:**
1. Fill "Lessons Learned" section in Decision.md
2. Extract to `30_RESOURCES/[category]/[topic].md`
3. Check extraction box in Decision.md
4. Move project to `40_ARCHIVE/Projects/`

## Validation

Check for required files:
```bash
# All research projects must have these
ls -1 "10_PROJECTS/Active/[project]/"
# Expected output:
# AGENTS.md
# Tasks.md
# Research.md
# Decision.md
# _Sources/
# _Notes/
```

## Common Mistakes to Avoid

❌ Storing sources directly in project root  
✅ Use `_Sources/` folder

❌ Mixing research notes and synthesis  
✅ Literature notes in `_Notes/`, synthesis in `Research.md`

❌ Archiving without extracting lessons  
✅ Complete Decision.md "Lessons Learned" first

❌ Generic file names (`notes.md`, `stuff.md`)  
✅ Follow naming conventions in folder READMEs

## Hyperlink Everything

All research output must include clickable hyperlinks to sources. This applies everywhere — _Sources files, _Notes, Research.md, and Decision.md.

**In _Sources files:**
- The **Source** field must be a full URL, not a bare domain or description
- Example: `**Source:** https://www.wirecutter.com/reviews/best-speakerphones/`
- NOT: `**Source:** Wirecutter` or `**Source:** wirecutter.com`

**In Research.md and _Notes:**
- Every claim, finding, or data point should cite its source with an inline hyperlink
- Format: `[Source Name](https://full-url)` or `According to [Wirecutter](https://www.wirecutter.com/reviews/best-speakerphones/), the top pick is...`
- If citing multiple sources for one finding, hyperlink each one

**In bibliographies and source lists:**
- Every entry must include the full URL as a clickable markdown link
- Format: `[N] Author/Org (Year). "[Title](https://url)". Publication.`

**Why:** Hyperlinked sources let Matt verify claims with one click, and they survive when notes are viewed outside Obsidian (e.g., in GitHub, Google Drive preview, or any markdown renderer).

## Hyperlink Everything

All research output must include clickable hyperlinks to sources. This applies everywhere — _Sources files, _Notes, Research.md, and Decision.md.

**In _Sources files:**
- The **Source** field must be a full URL, not a bare domain or description
- Example: `**Source:** https://www.wirecutter.com/reviews/best-speakerphones/`
- NOT: `**Source:** Wirecutter` or `**Source:** wirecutter.com`

**In Research.md and _Notes:**
- Every claim, finding, or data point should cite its source with an inline hyperlink
- Format: `[Source Name](https://full-url)` or `According to [Wirecutter](https://www.wirecutter.com/reviews/best-speakerphones/), the top pick is...`
- If citing multiple sources for one finding, hyperlink each one

**In bibliographies and source lists:**
- Every entry must include the full URL as a clickable markdown link
- Format: `[N] Author/Org (Year). "[Title](https://url)". Publication.`

**Why:** Hyperlinked sources let Matt verify claims with one click, and they survive when notes are viewed outside Obsidian (e.g., in GitHub, Google Drive preview, or any markdown renderer).
