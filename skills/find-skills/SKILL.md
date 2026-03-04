---
name: find-skills
description: Helps users discover and install agent skills by searching multiple registries and the web. Use when users ask 'how do I do X', 'find a skill for X', 'is there a skill that can...', or express interest in extending capabilities. This skill searches npx skills registry, playbooks.com, skills.sh, and the broader web to find skills across the fragmented ecosystem. Always use this skill when looking for skills — a single registry search is never enough.
---

# Find Skills (Multi-Source)

This skill discovers and compares agent skills across the fragmented skills ecosystem. It searches multiple registries **in parallel**, deduplicates results, scores them by popularity/quality, and presents a comparative view so the user can make informed choices.

All CLI commands run on the user's Mac Mini via `shell:run_command`.

## When to Use This Skill

Use this skill when the user:

- Asks "how do I do X" where X might be a common task with an existing skill
- Says "find a skill for X" or "is there a skill for X"
- Asks "can you do X" where X is a specialized capability
- Expresses interest in extending agent capabilities
- Wants to search for tools, templates, or workflows
- Mentions they wish they had help with a specific domain

## Sources (Searched in Parallel)

The skills ecosystem is fragmented — skills live across multiple registries and raw GitHub repos. **Always search ALL sources in parallel**, then merge, deduplicate, and rank results.

### Source 1: LobeHub Marketplace (PRIMARY — 100K+ skills)

The largest skills marketplace. Has install counts, ratings, GitHub stars, and category metadata. Always use `--output json` for structured data.

```bash
npx -y @lobehub/market-cli skills search --q "QUERY" --output json --page-size 10
```

JSON response includes per-skill: `identifier`, `name`, `description`, `installCount`, `ratingCount`, `isFeatured`, `isValidated`, `tags`, `github.stars`, `github.forks`, `github.watchers`.

**Install from LobeHub:**
```bash
npx -y @lobehub/market-cli skills install <identifier> --global
# Or for Claude Code specifically:
npx -y @lobehub/market-cli skills install <identifier> --agent claude-code
```

### Source 2: skills.sh Registry (npx skills)

Curated, smaller registry. Often has well-maintained skills from known publishers like `vercel-labs/agent-skills`.

```bash
npx skills find [query]
```

**Install from skills.sh:**
```bash
npx skills add <owner/repo@skill> -g -y
```

### Source 3: Playbooks.com Registry

Separate catalog with unique skills not found elsewhere. Search via web.

**Search:** Use `web_search` with: `site:playbooks.com/skills [query]`

**Key data on playbooks skill pages:** health score (out of 100), GitHub stars, install command, tags, trigger phrases.

**Install from Playbooks:**
```bash
npx playbooks add skill <owner/repo> --skill <skill-name>
```

### Source 4: GitHub Direct Search

Many skills exist as GitHub repos not indexed in any registry. Search for SKILL.md files.

**Search:** Use `web_search` with: `"SKILL.md" [query] site:github.com`

Or: `claude code skill [query] github`

**Popularity signals:** GitHub stars, forks, recent commits, open issues.

**Install from GitHub:**
```bash
npx skills add <github-owner/repo@skill-name> -g -y
```

### Source 5: General Web Fallback

If the above sources return thin results, broaden the search.

**Search:** Use `web_search` with: `"claude skill" OR "agent skill" [query]`

This can surface skills on skill0.atypica.ai, SkillsMP.com, SkillHub.club, blog posts, tutorials, etc.

## Search Workflow

### Step 1: Understand What They Need

Identify:
1. The domain (e.g., React, testing, finance, automation)
2. The specific task (e.g., virtual cards, writing tests, managing calendar)
3. 2-3 keyword variations to search with

### Step 2: Search ALL Sources in Parallel

**CRITICAL: Launch all searches at the same time.** Do NOT search sequentially or stop after the first hit. The user wants to compare options across the ecosystem.

Run these simultaneously:

1. `shell:run_command`: `npx -y @lobehub/market-cli skills search --q "QUERY" --output json --page-size 10`
2. `shell:run_command`: `npx skills find QUERY 2>&1`
3. `web_search`: `site:playbooks.com/skills QUERY`
4. `web_search`: `"SKILL.md" QUERY site:github.com`

If results are thin across all four, also run:
5. `web_search`: `"claude skill" OR "agent skill" QUERY`

### Step 3: Deduplicate Results

Skills often appear in multiple registries. Deduplicate by matching on:

- **GitHub repo URL** (most reliable — e.g., `github.com/openclaw/skills` appears on both LobeHub and Playbooks)
- **Skill name** (fuzzy match — "privacy-cards" on Playbooks = "openclaw-skills-privacy-cards" on LobeHub)
- **Author + description similarity**

When the same skill appears in multiple sources, **merge the data** into a single entry and note which sources listed it (this is itself a quality signal).

### Step 4: Score and Rank Each Skill

For each unique skill, compute a **popularity/quality score** from available signals:

**Registry signals:**
- LobeHub install count (e.g., 1.2k installs)
- LobeHub rating + rating count
- LobeHub `isFeatured` or `isValidated` flags
- Playbooks health score (out of 100)

**GitHub signals:**
- Stars (strong signal)
- Forks (indicates active use)
- Watchers
- Recent commits (is it maintained?)

**Cross-registry signals:**
- Number of sources that list the skill (found in 3/4 sources = well-known)
- Consistent descriptions across sources (legitimate, not auto-scraped junk)

**Scoring heuristic (for sorting, not displayed as a number):**
- 🟢 HIGH confidence: 100+ GitHub stars, or 50+ LobeHub installs, or listed in 3+ sources, or `isFeatured`
- 🟡 MEDIUM confidence: 10-99 stars, or 10-49 installs, or listed in 2 sources
- 🔴 LOW confidence: <10 stars, <10 installs, single source, no ratings

### Step 5: Present Results as a Comparison

Present ALL discovered skills in a comparison format. For each skill:

```
### skill-name (by author)
🟢 HIGH confidence
📝 One-line description of what it does
📊 Popularity: ⭐ 1,089 GitHub stars · 361 forks · 18 LobeHub installs · Health: C73/100
🔍 Found in: LobeHub, Playbooks, GitHub
🔧 Install: npx -y @lobehub/market-cli skills install <id> --global
⚠️ Requires: API key for Privacy.com (email apisupport@privacy.com)
🔗 Links: [LobeHub](url) · [Playbooks](url) · [GitHub](url)
```

**Sort by confidence level** (🟢 first), then by install count / stars within each tier.

If multiple skills serve the same purpose, explicitly compare them:
- "Skill A has more installs but Skill B was updated more recently"
- "Skill A is CLI-only while Skill B includes a web UI"

### Step 6: Fetch Details for Top Candidates

For the top 2-3 skills the user might want, use `web_fetch` to read the full skill page and verify:
- What the skill actually does in detail
- Installation instructions and prerequisites
- Any setup requirements (API keys, accounts, config)
- Whether it's actively maintained

### Step 7: Offer to Install

If the user picks one, install via `shell:run_command` on the Mac Mini:

```bash
# For LobeHub skills:
npx -y @lobehub/market-cli skills install <identifier> --global

# For skills.sh skills:
npx skills add <owner/repo@skill> -g -y

# For playbooks.com skills:
npx playbooks add skill <owner/repo> --skill <skill-name>
```

**After installing, automatically port to Claude Chat** using the skill-porter workflow. Install for all three targets: Claude Code, Claude Chat, and Claude CoWork.

## Example Search Flow

User asks: "Find me a skill for managing privacy.com virtual cards"

**Parallel searches launched:**
1. LobeHub: `npx -y @lobehub/market-cli skills search --q "privacy cards virtual" --output json`
2. skills.sh: `npx skills find privacy cards`
3. Web: `site:playbooks.com/skills privacy cards`
4. Web: `"SKILL.md" privacy cards site:github.com`

**Results merged and deduped:**
```
### privacy-cards (by openclaw/skills)
🟢 HIGH confidence
📝 Create and manage Privacy.com virtual cards — single-use, merchant-locked, spend limits, transactions
📊 Popularity: ⭐ 1,089 stars (repo) · 361 forks · 18 LobeHub installs · Health: C73/100
🔍 Found in: LobeHub, Playbooks, GitHub
🔧 Install: npx -y @lobehub/market-cli skills install openclaw-skills-privacy-cards --global
   Alt: npx playbooks add skill openclaw/skills --skill privacy-cards
⚠️ Requires: Privacy.com API key (email apisupport@privacy.com)
🔗 Links: [LobeHub](...) · [Playbooks](...) · [GitHub](...)
```

## Common Skill Categories

| Category        | Example Queries                                    |
| --------------- | -------------------------------------------------- |
| Web Development | react, nextjs, typescript, css, tailwind           |
| Testing         | testing, jest, playwright, e2e                     |
| DevOps          | deploy, docker, kubernetes, ci-cd                  |
| Documentation   | docs, readme, changelog, api-docs                  |
| Code Quality    | review, lint, refactor, best-practices             |
| Design          | ui, ux, design-system, accessibility               |
| Productivity    | workflow, automation, git                           |
| Finance         | payments, invoicing, virtual cards, budgeting      |
| APIs            | api integration, webhooks, oauth                   |
| Gaming          | dnd, game engine, multiplayer                      |

## Tips for Effective Searches

1. **Use 2-3 keyword variations** across sources — "privacy cards" AND "virtual cards" AND "payment cards"
2. **LobeHub is the biggest** — if it's not there, it might not exist as a packaged skill yet
3. **Playbooks often has niche skills** that LobeHub doesn't index
4. **GitHub search catches unregistered skills** — many devs build SKILL.md files but never publish to a registry
5. **Sort LobeHub by installCount** for popularity: `--sort installCount`

## When No Skills Are Found Anywhere

If no relevant skills exist across all sources:

1. Acknowledge that no existing skill was found across any registry
2. Offer to help with the task directly using general capabilities
3. Suggest building a custom skill with `npx skills init` or the skill-creator skill
4. If an API exists for the service, offer to build a custom skill

```
I searched LobeHub (100K+), skills.sh, playbooks.com, and GitHub but didn't find
a skill for "xyz".

I can still help you with this directly! And if this is something you do often,
we could create a custom skill for it using the skill-creator skill.
```
