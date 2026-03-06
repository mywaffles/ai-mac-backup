---
name: talking-parents-matt
description: >
  Automates TalkingParents (talkingparents.com) co-parenting messaging platform.
  Use this skill when the user mentions TalkingParents, TP, co-parenting messages,
  Stefanie, checking messages from their ex, syncing TP to Gmail, or any request
  involving reading, summarizing, or forwarding co-parenting communications.
  Triggers on: "check TalkingParents", "any new TP messages", "sync talking parents",
  "what did Stefanie say", "co-parenting messages", "check for messages from my ex",
  "email me TP messages", "TalkingParents to Gmail".
  All commands run on the user's Mac Mini via shell:run_command.
---

# TalkingParents Automation

Automates login, message reading, and Gmail sync for Matt's TalkingParents account
(messaging with Stefanie Abar).

## Important Safety Rules

- **NEVER click Send** — the circular up-arrow Send button must never be clicked. You may
  read any messages and draft responses, but never submit them. This is a legally monitored
  platform.
- **Accept any Terms of Service** dialogs that appear during login.
- Messages from Matt are right-aligned (`parent` CSS class, dark green background).
  Messages from Stefanie are left-aligned (no `parent` class, light green background).

## Prerequisites

- `playwright-cli` (globally installed via `@playwright/mcp@latest`)
- `gog` CLI (authenticated for `mattaabar@gmail.com`)
- 1Password `op` CLI with service account token in `~/.zshrc`
- TalkingParents credentials stored in 1Password vault "AI Agents", item ID: `u4pmgmtcge2hjhvtnht7dfpei4`

## Phase 1: Login

### 1a. Launch or Reuse the TalkingParents Browser

Always use a **separate** persistent browser profile — never Matt's main Chrome.

First, check if the TP browser is already running:

```bash
cd ~ && playwright-cli list
```

**If a browser with `user-data-dir: ...talkingparents-browser-profile` is listed:**
Open a new tab and navigate to TP (preserves the authenticated session, avoids MFA):

```bash
cd ~ && playwright-cli tab-new
cd ~ && playwright-cli goto https://app.talkingparents.com/messages
```

Note: `tab-new <url>` is buggy — it creates a blank tab but navigates the old tab.
Instead, create a blank tab first, then `goto` on it.

**If no browser is running:**
Launch a fresh instance with the persistent profile:

```bash
cd ~ && mkdir -p ~/.talkingparents-browser-profile
cd ~ && playwright-cli open https://app.talkingparents.com/messages --headed --profile ~/.talkingparents-browser-profile
```

The `--profile` flag gives a persistent Chromium instance that preserves cookies.

**IMPORTANT:** Prefer reusing the existing browser over launching a new one. A new
browser process will trigger MFA even with the same profile directory. Navigating within
the already-running browser shares the authenticated session and skips MFA entirely.
Do NOT use `tab-new` — it has a bug where it creates a blank tab.

### 1b. Check if Already Authenticated

After opening the browser, take a snapshot:

```bash
cd ~ && playwright-cli snapshot
```

- If the page title is "Co-Parenting Communication Tools" and the URL is `/messages`,
  you're already logged in — **skip to Phase 2**.
- If the page title is "Sign In" and the URL contains `/login`, proceed to 1c.

### 1c. Fill Credentials

Retrieve credentials from 1Password (never print the password):

```bash
export OP_SERVICE_ACCOUNT_TOKEN=$(grep OP_SERVICE_ACCOUNT_TOKEN ~/.zshrc | cut -d'"' -f2)
TP_USER=$(op item get u4pmgmtcge2hjhvtnht7dfpei4 --vault "AI Agents" --fields label=username --reveal 2>/dev/null)
TP_PASS=$(op item get u4pmgmtcge2hjhvtnht7dfpei4 --vault "AI Agents" --fields label=password --reveal 2>/dev/null)
```

From the login page snapshot, identify the Email textbox ref and Password textbox ref,
then fill them:

```bash
cd ~ && playwright-cli fill <email-ref> "$TP_USER"
cd ~ && playwright-cli fill <password-ref> "$TP_PASS"
cd ~ && playwright-cli click <sign-in-button-ref>
```

**Note:** playwright-cli logs the filled values in its output. This is a known limitation.

### 1d. Handle MFA

After clicking Sign In, snapshot again. If a "Multi-factor authentication" dialog appears
with a 6-digit code field:

1. Tell the user a code was sent to their phone (the number ending in **96).
2. Wait for the user to provide the code.
3. Fill the code field and click Verify.

The persistent profile should remember the session, so MFA should only be needed once
unless cookies expire.

### 1e. Handle Terms of Service

If a Terms of Service or consent dialog appears at any point, click Accept/Agree to
proceed. Snapshot after to confirm navigation.

## Phase 2: Read Messages

### 2a. Get Thread List

Once on the `/messages` page, snapshot to see the list of threads. The snapshot will show
`listitem` entries each containing:
- A heading (h3) with the thread subject
- A `time` element with the last activity date
- A preview snippet showing the last message sender and text

### 2b. Detect Unread/New Threads

TalkingParents shows threads with new messages in **bold**. To detect this:

```javascript
// Run via playwright-cli eval
(function(){
  var items = document.querySelectorAll('li.row');
  return Array.from(items).map(function(li){
    var h3 = li.querySelector('h3');
    var fw = h3 ? window.getComputedStyle(h3).fontWeight : '?';
    var preview = li.querySelector('.detail-item');
    var pfw = preview ? window.getComputedStyle(preview).fontWeight : '?';
    var title = h3 ? h3.textContent : '?';
    var time = li.querySelector('time');
    return title.substring(0,50) + ' | h3-fw:' + fw + ' preview-fw:' + pfw + ' | ' + (time ? time.textContent : '');
  }).join('\n');
})()
```

If all h3 font-weights are 700 (the default heading style), check whether preview text
font-weight differs (400 = read, 700 = unread). If everything looks the same, there may
be no new messages — but still check the most recent threads by date.

### 2c. Open and Read a Thread

Click the thread heading ref to open it. The conversation panel appears on the right side.
Use this JavaScript via `playwright-cli eval` to extract all messages:

```javascript
(function(){
  var feed = document.querySelector('.message-feed');
  if(!feed) return 'no feed';
  var replies = feed.querySelectorAll('.reply-root');
  var result = [];
  replies.forEach(function(r, i){
    var isParent = r.classList.contains('parent');
    var text = '';
    var textEl = r.querySelector('.text');
    if(textEl) text = textEl.textContent.trim().substring(0, 500) || '';
    var timeEl = r.querySelector('time');
    var time = timeEl ? timeEl.textContent.trim() : '';
    result.push((isParent ? 'Matthew' : 'Stefanie') + ' (' + time + '): ' + text);
  });
  return result.join('\n---\n');
})()
```

Key CSS classes:
- `.message-feed` — the conversation container
- `.reply-root` — each message
- `.reply-root.parent` — messages from Matt (right-aligned, dark green)
- `.reply-root` without `.parent` — messages from Stefanie (left-aligned, light green)
- `.text` — the message text content within a reply
- `.viewed-by` — read receipts ("Stefanie viewed on ...")
- `.created-metadata` — thread creation info

### 2d. Close a Thread

Find the "Close conversation" button ref in the snapshot and click it to return to the
thread list. The ref changes each snapshot, so always re-read from the latest snapshot.

### 2e. Navigate Multiple Threads

Repeat 2c-2d for each thread you need to read. Work from most recent to oldest.

## Phase 3: Sync to Gmail

Match TalkingParents threading: one Gmail thread per TP subject.

### 3a. Search for Existing Gmail Thread

For each TP thread subject, search Gmail:

```bash
export GOG_ACCOUNT=mattaabar@gmail.com
gog gmail search "subject:\"TalkingParents: <thread-subject>\"" --json
```

Use the prefix "TalkingParents: " to distinguish TP-synced emails from other mail.

### 3b. Send New Email (No Existing Thread)

If no matching Gmail thread exists, compose a new email with the full conversation:

```bash
export GOG_ACCOUNT=mattaabar@gmail.com
gog gmail send \
  --to mattaabar@gmail.com \
  --subject "TalkingParents: <thread-subject>" \
  --body "<formatted-conversation>"
```

Format the body with each message on its own line:
```
[Matthew, 3/20/2025 9:51 AM]
<message text>

[Stefanie, 2/18/2026 3:36 PM]
<message text>
```

### 3c. Reply to Existing Thread (New Messages)

If a Gmail thread already exists, reply with only the **new** messages since the last
sync. Use the `--reply-to-message-id` flag:

```bash
gog gmail send \
  --to mattaabar@gmail.com \
  --subject "Re: TalkingParents: <thread-subject>" \
  --body "<new-messages-only>" \
  --reply-to-message-id <messageId>
```

Get the messageId from the Gmail search results.

### 3d. Determining What's New

Compare the messages found in TP against what's already been emailed. The simplest
approach is to check the timestamp of the last message mentioned in the most recent
Gmail message in the thread, and only forward messages newer than that.

## Phase 4: Cleanup

When finished, **do NOT close the browser**. Keeping it running preserves the
authenticated session so the next run skips MFA entirely.

If the user explicitly asks to close it:
```bash
cd ~ && playwright-cli close
```

But warn them that the next run will require MFA again.

## Quick Reference: Common Workflows

### "Check for new TP messages"
Phase 1 (login) -> Phase 2a-2b (list + detect unread) -> Phase 2c for unread threads -> Report to user

### "Sync TP to Gmail"
Phase 1 -> Phase 2 (read all recent threads) -> Phase 3 (email each thread) -> Phase 4

### "What did Stefanie say about X?"
Phase 1 -> Phase 2a (find thread by subject) -> Phase 2c (read thread) -> Summarize

### "Read the latest TP messages and email them to me"
Phase 1 -> Phase 2 -> Phase 3 -> Phase 4

## Known Issues and Learnings

- `playwright-cli` logs filled values (including passwords) in its output. Use the
  persistent profile to minimize re-authentication.
- The `/.playwright-cli` directory error occurs if not running from `cd ~`. Always prefix
  commands with `cd ~`.
- Closing and reopening the browser triggers MFA even with a persistent profile. Always
  reuse the running browser via `playwright-cli goto` instead of launching a new one.
- `tab-new <url>` has a bug: it creates a blank tab and navigates the original tab.
  Workaround: `tab-new` (no URL) then `goto <url>` on the new tab.
- Thread list may show duplicate entries at the bottom (rendering artifact) — deduplicate
  by subject + date.
- MFA codes are sent via SMS. BlueBubbles server or iMessage database access may not be
  available. Ask the user to provide the code manually.
- The `parent` CSS class on `.reply-root` indicates Matt's messages. Non-`parent` are
  Stefanie's. There is no sender name element — alignment and class are the only
  differentiators.
- Snapshot refs (e.g., e220, e600) change with every snapshot — never hardcode them.
  Always read from the latest snapshot.
