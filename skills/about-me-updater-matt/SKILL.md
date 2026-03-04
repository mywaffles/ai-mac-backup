---
name: about-me-updater
description: >
  Keeps Matt's "About Me" Google Doc automatically updated as Claude learns new information about him.
  Use this skill whenever Claude discovers new personal facts about Matt during conversation — things he owns,
  family updates, medical changes, financial changes, address/contact changes, new hobbies, new skills,
  vehicle changes, computer/hardware changes, employment changes, or any other life updates that belong
  in his personal reference document. Also use when Matt explicitly asks to "update my About Me",
  "add this to my doc", "remember this in my doc", or references his personal info document.
  This skill should trigger proactively — if Matt mentions buying something, moving, changing jobs,
  getting a new pet, a medical update, or any factual life change, Claude should offer to update
  the doc without being asked. All commands run on Matt's Mac Mini via shell:run_command.
---

# About Me Doc Updater

## Purpose

Matt maintains a comprehensive personal reference document in Google Drive called
"About Me - Matt Abar Important Info". This skill keeps it current by detecting new
personal information during conversations and writing updates to the doc via the `gog` CLI.

## Document Details

- **Title**: "About Me - Matt Abar Important Info"
- **Subtitle** (inside doc): "Last updated: <date>" — update this whenever you make changes
- **Google Doc ID**: `14FWrZCYqb-2AP6k305OA6osDRUNwYNmlhNQ4-Unp3yc`
- **Google Account**: `mattaabar@gmail.com`
- **Tool**: `gog` CLI via `shell:run_command`

## Document Structure

The doc is organized into these sections (in order). When adding information, place it
in the correct section to maintain organization:

1. My Information — Passport, driver's license, IDs
2. Current Contact Info — Address, phone, email
3. Prior Contact Info — Historical addresses
4. My Bio — Life story, background
5. Emergency & Advance Care Info — Emergency contacts, hospital, directives
6. Work — Current and past employers
7. Family — Lorelei, Kerrigan, details about each
8. Pets — Grey (cat), Pita (deceased cat)
9. Living — Living family members and contact info
10. Ex-Wife — Stefanie and her family
11. Friends — Friend contact info
12. Deceased — Deceased family members
13. Medical — Diagnoses, medications, allergies, immunizations, test results
14. Mental Health — Therapist, diagnoses
15. Vision — Prescriptions, glasses
16. Insurance — Health plan details
17. Financial — Banking, investments, credit, business interests, net worth
18. Legal — Attorney, divorce details
19. Skills — Certifications, licenses
20. Things I Own — Tools (extensive subsections), home theater, computers, printers, appliances
21. Hobbies — Activities, interests
22. Vehicles — Current vehicles
23. Used to Own — Historical record of retired physical items

## Formatting Rules

The doc uses plain text lines. No bullet points, no `*` prefixes, no markdown-style lists.
Each item is a plain line of text. Sub-items are indented with spaces. Section headers are
plain text on their own line. Follow the conventions of the surrounding section exactly.

Example of correct formatting:
```
Miscellaneous Hardware
NVIDIA GeForce RTX 2070 SUPER (4K display at 3840 × 2160 @ 59 Hz)
Anker PowerConf — Bluetooth Speakerphone (connected to Mac Mini, Mar 2026)
```

NOT this:
```
Miscellaneous Hardware
* NVIDIA GeForce RTX 2070 SUPER
* Anker PowerConf — Bluetooth Speakerphone
```

## How to Update the Doc

### Step 1: Always read before writing

Before making any changes, export the doc and read the relevant section to understand
the current content, formatting, and find the right anchor text. This is mandatory.

```bash
shell:run_command: export GOG_ACCOUNT=mattaabar@gmail.com && gog docs export 14FWrZCYqb-2AP6k305OA6osDRUNwYNmlhNQ4-Unp3yc --format txt --out /tmp/about-me.txt && grep -n -A 20 "SECTION_HEADER" /tmp/about-me.txt
```

Read the section, understand what's there, then decide:
- Where exactly the new content should go (which line, after which item)
- What anchor text to use for the find-replace (pick a unique line near the insertion point)
- Whether the info already exists (don't duplicate)
- Whether a new section needs to be created

Do NOT rely on memorized anchor text from the skill file or past conversations. The doc
changes over time. Always read the current state and determine the correct anchor from
what you actually see.

### Step 2: Make the change with find-replace

Use `find-replace` to insert or modify content. The find string must be unique in the doc.
Use enough surrounding context to guarantee uniqueness.

**Adding content after an existing line:**
```bash
shell:run_command: export GOG_ACCOUNT=mattaabar@gmail.com && gog docs find-replace 14FWrZCYqb-2AP6k305OA6osDRUNwYNmlhNQ4-Unp3yc "ANCHOR_LINE" "ANCHOR_LINE
NEW_CONTENT_HERE"
```

**Modifying existing content:**
```bash
shell:run_command: export GOG_ACCOUNT=mattaabar@gmail.com && gog docs find-replace 14FWrZCYqb-2AP6k305OA6osDRUNwYNmlhNQ4-Unp3yc "OLD_TEXT" "NEW_TEXT"
```

### Step 3: Update the subtitle

After every change, update the "Last updated" subtitle:
```bash
shell:run_command: export GOG_ACCOUNT=mattaabar@gmail.com && gog docs find-replace 14FWrZCYqb-2AP6k305OA6osDRUNwYNmlhNQ4-Unp3yc "Last updated: OLD_DATE" "Last updated: NEW_DATE"
```

### Step 4: Verify

Re-export and grep to confirm the change landed correctly:
```bash
shell:run_command: export GOG_ACCOUNT=mattaabar@gmail.com && gog docs export 14FWrZCYqb-2AP6k305OA6osDRUNwYNmlhNQ4-Unp3yc --format txt --out /tmp/about-me-verify.txt && grep -n -A 5 "SECTION_HEADER" /tmp/about-me-verify.txt
```

## Retiring / Archiving Information

**Never delete information from the doc.** When something is no longer current, mark it as
historical so the doc remains a complete record. There are two methods depending on the
type of information:

### Method 1: Move to "Used to Own" (physical items)

Use for: tools, hardware, vehicles, appliances, peripherals, furniture — any physical thing.

1. Read the doc to find the item's exact text in its current section
2. Remove it from its current location (find-replace the item text with empty string)
3. Append it to the "Used to Own" section at the bottom of the doc with reason and date

Example:
```
Used to Own
Samsung Bespoke AI All-in-One Vented Combo - 5.3 cu.ft. - WD90F53AVSUS (retired Mar 2026)
LG Styler Smart Wi-Fi Enabled Steam Closet - 3 Hangers - S3WFBN (retired Mar 2026)
DEWALT DCS367B — 20V MAX XR Compact Reciprocating Saw (sold ~Mar 2026)
NVIDIA GeForce RTX 2070 SUPER (gave to Jason, Feb 2026)
```

### Method 2: Annotate in place (non-physical items)

Use for: medical diagnoses, medications, jobs, contacts, accounts, subscriptions,
hobbies, certifications, insurance, relationships. These stay in their original section
but get marked as no longer active.

**Medical diagnoses — use date ranges:**
All diagnoses should have a date range in parentheses showing when the diagnosis was
active. Active diagnoses have an open-ended range. Dropped diagnoses get the end date
filled in and strikethrough applied.

Active diagnosis format:
```
Hereditary Hemochromatosis — chronic iron overload disorder (diagnosed ~2020 – present)
Hypertension (benign) — stable blood pressure condition under treatment (diagnosed ~2019 – present)
```

Dropped/revised diagnosis format:
```
~~Hereditary Hemochromatosis — chronic iron overload disorder~~ (diagnosed ~2020 – dropped Mar 2026 by Dr. Nicklas)
```

When adding a NEW diagnosis, always include the date range with "present" as end date.
When DROPPING a diagnosis, apply strikethrough and replace "present" with the drop date and provider.

**Medications — strikethrough with annotation:**
```
~~Tirzepatide 15 mg injection (Mounjaro)~~ (discontinued Mar 2026 by Dr. Nicklas)
```

**Jobs / employers:**
Move from "Current Employer" to "Past Employers" with end date. Don't delete.

**Contact info:**
Move from "Current Contact Info" to "Prior Contact Info" with date range.

**Subscriptions, insurance, financial accounts:**
Mark as closed/cancelled with date:
```
Betterment Roth IRA (5509): Closed Jan 2026
```

**People (friends, family, contacts):**
If someone passes away, move from "Living" to "Deceased" with date.
If a relationship ends (friend, therapist, etc.), add "(no longer active as of <date>)"
rather than removing.

**Hobbies, skills, certifications:**
Add "(inactive as of <date>)" or "(expired <date>)" rather than removing.

## Important Guidelines

- **Always read before writing** — Export the doc and read the relevant section first. Determine the correct anchor text from the current state of the doc, not from memory or past conversations.
- **Match existing style** — Plain text lines, no bullets, no markdown. Follow the conventions of the surrounding section.
- **Confirm with Matt** — Before making changes, tell Matt what you plan to add and where. Example: "I noticed you mentioned buying an Anker PowerConf speakerphone. Want me to add it to the Miscellaneous Hardware section of your About Me doc?"
- **Don't duplicate** — Check if the information already exists before adding it.
- **Use dates when relevant** — For items that change over time (medical, financial, employment), include the date of the change.
- **Never hard-delete** — Information is always preserved in some form: moved, struck through, or annotated. The doc is a living historical record, not just a snapshot of the present.
- **Update the subtitle** — After every change, update the "Last updated:" line in the doc subtitle.
- **Rollback** — If a find-replace goes wrong, Matt can use Google Docs version history (File > Version history) to restore a previous state. Mention this if something doesn't look right.

## What Triggers This Skill

Watch for these types of new information during any conversation:

- **Purchases / Things owned**: "I just bought a...", "I got a new...", mentions of products, hardware, tools
- **Getting rid of things**: "I sold my...", "I gave away...", "I returned the...", "I don't have the... anymore"
- **Contact changes**: New address, phone number, email
- **Employment**: Job changes, title changes, salary updates, leaving a job
- **Family updates**: Events involving Lorelei, Kerrigan, or other family
- **Medical**: New diagnoses, medication changes, stopped a medication, doctor visits, test results, diagnosis revised/dropped
- **Financial**: Account changes, major transactions, investment updates, closed accounts
- **Vehicles**: New vehicle, sold a vehicle, traded in
- **Hobbies/Skills**: New certifications, new activities, stopped doing something
- **Legal**: Case updates, court orders, attorney changes
- **Pets**: Health updates, new pets, pet passing
- **Hardware/Computers**: New devices, upgrades, peripherals, retired/replaced hardware
- **Friends**: New contacts, updated info, lost touch
- **Insurance**: Plan changes, new coverage, dropped coverage

## Section Placement Guide

### Adding new items

| New info about... | Goes in section... | Anchor near... |
|---|---|---|
| Bluetooth speaker, peripherals | Miscellaneous Hardware | After the last item in that subsection |
| New tool (power/hand) | Things I Own > Tools > appropriate subsection | After similar tools |
| Computer upgrade | Computers > Matt Desktop or Matt Laptop | After existing specs |
| New monitor, printer, 3D printer | Printers, Scanners, etc. | After last item |
| New streaming device, TV gear | Home Theater (TV Room) | After last item |
| New vehicle | Vehicles | After last vehicle |
| New medication | Current Medications | After last medication |
| New diagnosis | Active Diagnoses | After last diagnosis (include date range) |
| New glasses | My Glasses | After last pair |
| New investment account | Investment Accounts | After last account |
| New hobby | Hobbies | After last hobby |
| New friend | Friends | After last friend |
| New family info | Family > relevant person | Within that person's section |

### Retiring items

| Retired info about... | Method | Action |
|---|---|---|
| Tool, hardware, appliance, peripheral | Move to Used to Own | Remove from current section, append to Used to Own with date/reason |
| Vehicle sold/traded | Move to Used to Own | Remove from Vehicles, append to Used to Own with date/reason |
| Diagnosis dropped/revised | Annotate in place | Strikethrough, fill in end date in range, add provider |
| Medication discontinued | Annotate in place | Strikethrough + "(discontinued <date> by <provider>)" |
| Job ended | Move within section | Move from Current Employer to Past Employers with end date |
| Address changed | Move within section | Move from Current to Prior Contact Info with date range |
| Account closed | Annotate in place | Add "(Closed <date>)" |
| Person deceased | Move within section | Move from Living to Deceased with date |
| Hobby/cert stopped or expired | Annotate in place | Add "(inactive/expired <date>)" |
| Insurance plan ended | Annotate in place | Add "(ended <date>)" |

## Example Workflows

### Adding a new item

1. Matt mentions: "I just connected my Anker PowerConf speakerphone"
2. Claude recognizes this as a new hardware item Matt owns
3. Claude offers: "Want me to add the Anker PowerConf to the Miscellaneous Hardware section of your About Me doc?"
4. If Matt agrees, Claude:
   a. Exports the doc and reads the Miscellaneous Hardware section to find the last item
   b. Uses find-replace to insert the new item after the last existing item
   c. Updates the "Last updated" subtitle
   d. Verifies the change

### Retiring a physical item

1. Matt mentions: "I sold my RTX 2070 SUPER on eBay"
2. Claude offers: "Want me to move the RTX 2070 SUPER from Miscellaneous Hardware to Used to Own in your About Me doc?"
3. If Matt agrees, Claude:
   a. Reads the doc to find the exact text of the RTX 2070 SUPER entry
   b. Removes it from Miscellaneous Hardware via find-replace
   c. Reads the Used to Own section to find the last item
   d. Appends the item to Used to Own with "(sold ~Mar 2026)" via find-replace
   e. Updates the "Last updated" subtitle
   f. Verifies both changes

### Retiring a medical diagnosis

1. Matt mentions: "Dr. Nicklas dropped my hemochromatosis diagnosis"
2. Claude offers: "Want me to mark Hereditary Hemochromatosis as dropped in your About Me doc?"
3. If Matt agrees, Claude:
   a. Reads the Active Diagnoses section
   b. Applies strikethrough and fills in the end date:
      `~~Hereditary Hemochromatosis — chronic iron overload disorder~~ (diagnosed ~2020 – dropped Mar 2026 by Dr. Nicklas)`
   c. Updates the "Last updated" subtitle
   d. Verifies the change

### Retiring a medication

1. Matt mentions: "Dr. Nicklas took me off Wellbutrin last week"
2. Claude offers: "Want me to mark Wellbutrin as discontinued in your About Me doc?"
3. If Matt agrees, Claude:
   a. Finds the Wellbutrin line in Current Medications
   b. Wraps it in strikethrough and adds annotation:
      `~~Bupropion XL 150 mg tablet (Wellbutrin XL)~~ (discontinued Feb 2026 by Dr. Nicklas)`
   c. Updates the "Last updated" subtitle
   d. Verifies the change
