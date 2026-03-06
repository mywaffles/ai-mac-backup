# Learnings Log

Learnings, corrections, and better approaches discovered during work.

**Status:**
- `pending` - Not yet addressed
- `in_progress` - Actively being worked on
- `resolved` - Fixed
- `promoted` - Elevated to AGENTS.md, TOOLS.md, or SOUL.md
- `wont_fix` - Decided not to address

---

## [LRN-20260304-001] real-time-todo-updates

**Logged**: 2026-03-04T14:02:00-07:00
**Priority**: high
**Status**: resolved
**Area**: workflow

### Summary
Must update TODO files immediately upon discovering task completion, not batch at end of conversation

### Details
During Greece trip research, discovered Stefanie notification was sent (Dec 30, 2025) but didn't update TODO.md until after completing all research. User corrected: "You should have updated the ToDo as soon as you discovered I notified Stefanie."

### Suggested Action
Updated AGENTS.md and personal-todos skill with explicit rule:
1. The moment you discover a task is complete → Update TODO.md NOW
2. Then update Research.md if applicable
3. THEN continue with remaining research
4. Never batch updates - sync in real-time

### Resolution
- **Resolved**: 2026-03-04T14:05:00-07:00
- **Changes**: Updated AGENTS.md, personal-todos/SKILL.md, para-second-brain/references/research-projects.md
- **Status**: promoted
- **Promoted**: AGENTS.md (top-level rule)

### Metadata
- Source: user_feedback
- Related Files: AGENTS.md, ~/.agents/skills/personal-todos/SKILL.md
- Tags: workflow, todos, real-time-sync
- Category: correction

---

## [LRN-20260304-002] pinchchat-new-session-behavior

**Logged**: 2026-03-04T15:17:00-07:00
**Priority**: medium
**Status**: pending
**Area**: config

### Summary
`/new` command in PinchChat routed to Telegram session instead of creating new WebChat thread

### Details
User logged into PinchChat, tried `/new` command expecting to create a new chat thread. Instead was moved to existing Telegram session. No visible "New Chat" button in PinchChat sidebar.

PinchChat advertises "Multi-session navigation" and "sessions in a sidebar", suggesting it should support multiple threads.

### Suggested Action
Research:
1. How does OpenClaw create multiple sessions for same channel (WebChat)?
2. Does PinchChat have UI for creating new sessions (button/menu)?
3. Is `/new` the wrong command for this?
4. Need sessions_spawn or different approach?

### Metadata
- Source: user_feedback
- Related Files: pinchchat/src/components/, openclaw session management
- Tags: pinchchat, sessions, webchat
- Category: usability

---

