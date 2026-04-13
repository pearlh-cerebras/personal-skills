---
name: pr-review-checklist
description: Generates a tailored code review checklist for a pull request based on the diff and any reviewer notes provided.
---

# PR Review Checklist

Given a PR diff or description, produce a focused review checklist so the reviewer doesn't miss anything important.

---

## Step 1: Understand the PR

Ask the user for the PR URL, branch name, or paste of the diff. Also ask:
- What is this PR supposed to do?
- Any areas you're particularly unsure about?

If the user can provide a diff, read it. If in a git repo, offer to run:
```bash
git diff main...HEAD --stat
git diff main...HEAD
```

## Step 2: Identify risk areas

Scan for:
- **Logic changes** — conditional branches, edge cases, off-by-one errors
- **Security** — user input handling, SQL queries, auth checks, secrets in code
- **Data changes** — schema migrations, backward compatibility, data loss risk
- **Tests** — are new behaviors covered? are existing tests still valid?
- **Performance** — N+1 queries, large loops, unnecessary re-renders
- **Error handling** — are errors surfaced correctly, or silently swallowed?

Skip categories that are clearly not relevant to this PR.

## Step 3: Output the checklist

Format as a markdown checklist grouped by area. Keep items specific to the actual diff — no generic boilerplate.

Example output:
```
## Logic
- [ ] Check the `offset` edge case when `page=0`
- [ ] Verify the fallback branch in `handleError` returns the right status code

## Tests
- [ ] Add a test for the new `parseDate` helper with invalid input

## Security
- [ ] Confirm `user_id` is validated server-side before the DB query
```

Ask if they want to add/remove any areas before they use it.
