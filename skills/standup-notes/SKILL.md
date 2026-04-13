---
name: standup-notes
description: Generates a concise daily standup update from recent git commits and freeform notes the user provides.
---

# Standup Notes

Given recent git activity and any notes the user has, produce a clean, brief standup update.

---

## Step 1: Gather context

Ask the user:
- What repo/branch are you working on? (or offer to run `git log --oneline -10` if they're in a repo)
- Anything blocked or worth flagging?
- Any PRs open or in review?

If the user is already in a repo context, run:
```bash
git log --oneline --since="yesterday" --author="$(git config user.name)" 2>/dev/null | head -20
```

## Step 2: Draft the standup

Format the update as three short bullets:

**Yesterday:** What was completed (pull from commits + notes)
**Today:** What's planned next (infer from open PRs, branch name, user notes)
**Blockers:** Any blockers or dependencies (from user input; omit section if none)

Keep each bullet to 1-2 lines. Use plain English, no jargon. Do not list every commit — summarize the theme.

## Step 3: Deliver

Output the formatted standup. Ask if the user wants to adjust the tone (more formal, shorter, etc.) before they copy it.
