---
name: find-skills
description: "Helps users discover and install agent skills by searching multiple registries and the web. Use when users ask 'how do I do X', 'find a skill for X', 'is there a skill that can...', or express interest in extending capabilities. This skill searches npx skills registry, playbooks.com, skills.sh, and the broader web to find skills across the fragmented ecosystem. Always use this skill when looking for skills — a single registry search is never enough."
---

# Find Skills (Multi-Source)

This skill helps you discover and install skills by searching across multiple registries and the broader web. The skills ecosystem is fragmented — skills live in different registries (skills.sh, playbooks.com) and on raw GitHub repos, so searching a single source misses a lot.

## When to Use This Skill

Use this skill when the user:

- Asks "how do I do X" where X might be a common task with an existing skill
- Says "find a skill for X" or "is there a skill for X"
- Asks "can you do X" where X is a specialized capability
- Expresses interest in extending agent capabilities
- Wants to search for tools, templates, or workflows
- Mentions they wish they had help with a specific domain

## Search Strategy: Always Search Multiple Sources

**IMPORTANT:** Never rely on a single source. Always search at least 2-3 sources, especially if the first one returns no results.

### Source 1: npx skills registry (skills.sh)

The Skills CLI (`npx skills`) is one package manager for the open agent skills ecosystem.

```bash
npx skills find [query]
```

Results look like:
```
Install with npx skills add <owner/repo@skill>
vercel-labs/agent-skills@vercel-react-best-practices
└ https://skills.sh/vercel-labs/agent-skills/vercel-react-best-practices
```

**Install from this source:**
```bash
npx skills add <owner/repo@skill> -g -y
```

**Browse at:** https://skills.sh/

### Source 2: Playbooks.com registry

Playbooks.com hosts a separate skill registry with skills not found on skills.sh.

**Search via web:** Use web_search with queries like:
```
site:playbooks.com/skills [query]
```

Or browse directly: https://playbooks.com/skills

**Install from this source:**
```bash
npx playbooks add skill <owner/repo> --skill <skill-name>
```

Example: `npx playbooks add skill openclaw/skills --skill privacy-cards`

### Source 3: Web search (GitHub + general)

Many skills exist as GitHub repos that aren't indexed in any registry. Search the web with queries like:

```
"claude skill" OR "agent skill" [query] site:github.com
```

```
"SKILL.md" [query] site:github.com
```

```
claude code skill [query]
```

Skills found this way can often be installed directly from GitHub:
```bash
npx skills add <github-owner/repo@skill-name> -g -y
```

Or if they're a Playbooks skill:
```bash
npx playbooks add skill <owner/repo> --skill <skill-name>
```

### Source 4: Direct URL fetch

If you find a promising skill page (on playbooks.com, skills.sh, or GitHub), use web_fetch to read the full details before recommending it. This lets you verify:
- What the skill actually does
- Installation instructions
- Any setup requirements (API keys, config, etc.)

## Search Workflow

### Step 1: Understand What They Need

Identify:
1. The domain (e.g., React, testing, finance, automation)
2. The specific task (e.g., virtual cards, writing tests, managing calendar)
3. Keywords to search with

### Step 2: Search Multiple Sources (in parallel when possible)

Run these searches — do NOT stop after the first one:

1. `npx skills find [query]` — via shell:run_command on Mac Mini
2. Web search: `site:playbooks.com/skills [query]`
3. Web search: `"claude skill" OR "SKILL.md" [query] github.com` (if first two are thin)

### Step 3: Fetch and verify promising results

For any promising hits, use web_fetch to read the skill page and understand what it does, how to install it, and any setup requirements.

### Step 4: Present Options to the User

For each skill found, present:
1. The skill name and what it does
2. Which registry/source it came from
3. The exact install command
4. Any setup requirements (API keys, accounts, etc.)
5. A link to learn more

Example:
```
I found a Privacy.com virtual cards skill on Playbooks.com!

**privacy-cards** by openclaw/skills
Creates and manages Privacy.com virtual cards — single-use, merchant-locked, 
spend limits, transaction history via the Privacy.com API.

Install: npx playbooks add skill openclaw/skills --skill privacy-cards
Details: https://playbooks.com/skills/openclaw/skills/privacy-cards

⚠️ Requires a Privacy.com API key (email apisupport@privacy.com to request access)
```

### Step 5: Offer to Install

If the user wants to proceed, install via shell:run_command on the Mac Mini:

```bash
# For skills.sh skills:
npx skills add <owner/repo@skill> -g -y

# For playbooks.com skills:
npx playbooks add skill <owner/repo> --skill <skill-name>
```

After installing, offer to port to Claude Chat using the skill-porter workflow.

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

## Tips for Effective Searches

1. **Use specific keywords**: "react testing" beats just "testing"
2. **Try alternative terms**: If "deploy" doesn't work, try "deployment" or "ci-cd"
3. **Search broadly**: A skill for "privacy.com" might be called "virtual cards" or "payment cards"
4. **Check multiple sources**: skills.sh and playbooks.com have different inventories
5. **Don't give up after one search**: Rephrase and try another source

## When No Skills Are Found Anywhere

If no relevant skills exist across all sources:

1. Acknowledge that no existing skill was found across any registry
2. Offer to help with the task directly using general capabilities
3. Suggest the user could create their own skill with `npx skills init`
4. If an API exists for the service, offer to build a custom skill

```
I searched skills.sh, playbooks.com, and GitHub but didn't find a skill for "xyz".

I can still help you with this directly! And if this is something you do often, 
we could create a custom skill for it:
npx skills init my-xyz-skill
```
