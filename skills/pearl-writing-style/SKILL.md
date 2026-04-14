---
name: pearl-writing-style
description: Writes Confluence docs in Pearl Hulbert's voice and style — direct, data-anchored, no fluff. Covers structure, tone, formatting, and section patterns for proposals, findings, guides, and vision docs. Use whenever creating or rewriting a Confluence page for Pearl or the Growth team.
tools: mcp__atlassian__createConfluencePage, mcp__atlassian__updateConfluencePage, mcp__atlassian__getConfluencePage, mcp__atlassian__searchConfluenceUsingCql, mcp__atlassian__getConfluenceSpaces, mcp__atlassian__atlassianUserInfo
---

# Pearl's Confluence Writing Style

Apply this style whenever writing or editing a Confluence doc for Pearl Hulbert or the Growth team. The goal is writing that sounds like Pearl wrote it — not like an AI, not like a consultant, not like a template.

---

## Voice & Tone

**Direct and confident.** No throat-clearing, no hedging, no preamble. The first sentence of every section carries weight.

**Data-anchored.** Specific numbers over vague claims. "38 Cerebras Code customers per week" not "a significant number of customers." "3–5 hours per week" not "a lot of time."

**Conversational but precise.** Write like a capable person explaining something clearly to a peer — not formal, not casual. Never padded.

**Impact-first.** Lead with why this matters before explaining how it works. The reader should understand the stakes in the first paragraph.

**Recommendation-forward.** Don't bury the conclusion. State what the recommendation is, then support it.

---

## Structural Patterns by Doc Type

Match the section structure to what the doc is doing. Don't apply a one-size-fits-all template.

### Findings / Analysis Docs

```
Executive Summary     ← 3–5 sentence bottom line up front
---
[Data Section]        ← tables, metrics, key insight callout
---
Recommendation        ← clear, named option with rationale
---
Scenarios/Options     ← numbered, quantified impact per scenario
```

### Proposal Docs

```
Overview / Why        ← problem statement with real numbers
---
[Feature/Option Sections]  ← what it does, not just what it is
---
How It Works          ← brief, jargon-light mechanics
---
Pricing / Cost        ← break-even math if relevant
---
Next Steps            ← numbered, owner-implied
```

### Guide Docs

```
[Title]
One-sentence description of what this covers and who it's for.
---
Table of Contents     ← numbered, linked
---
[Sections]            ← concept before implementation, one idea per section
---
Quick Reference       ← command/item table at the end
---
Getting Help          ← Slack + links
```

### Vision Docs

```
Vision                ← tagline paragraph, no header needed
---
What [This] Is        ← definition + contrast with the status quo
---
Who's Contributing / Use Cases  ← concrete examples, not abstractions
---
Early Wins            ← named results with real numbers
---
Why This Is Worth Building  ← compounding impact, not just one-time value
---
→ [Link to Getting Started or next action]
```

### Options / Decision Docs

```
Context / Why We're Deciding This
---
Known Friction Points   ← from real use, not hypothetical
---
Option [N] — [Name]     ← one section per option, pros/cons table each
---
Side-by-side Comparison ← feature matrix table across all options
---
Recommendation          ← clear winner + why + caveat for edge cases
---
What Changes Based on Your Situation  ← table for common variants
```

---

## Formatting Rules

### Bullets with Bold Labels
Use this pattern for lists where each item has a name and an explanation:

```
* **Discord is biased and incomplete**. It captures a small, highly opinionated subset of users.
* **Stripe is structurally incomplete**. We only record the date a cancellation is scheduled.
```

Not just a list of nouns. Not bullet + colon. Bold label, period, then the point.

### Tables for Comparisons and Reference
Use tables for: pros/cons, option comparisons, quick-reference commands, side-by-side feature matrices.

```markdown
| **Tier** | **Total Daily Tokens** | **Cache Hit Rate** |
|---|---|---|
| **Free Tier** | 838M | 25% |
| **Paid** | 2.6B | 75% |
```

Bold the column headers and any key values (like tier names).

### Key Insight Callouts
After a data table or important finding, add a standalone callout:

```
**Key Insight:** Despite having only ~32% of the total volume of Paid users, the Free Tier generates **more uncached load (625M vs 583M)**.
```

Keep it to one or two sentences. Make it impossible to miss.

### Metrics as Bullet Points
When presenting results or demo outcomes, use bullets with bold metrics:

```
* **37 test cases generated**
* **35 tests passed**
* **3 minutes** to generate the test plan
* **13 minutes** to execute the test suite
```

### Code Blocks
Anything the reader types, runs, or copies goes in a fenced code block. No inline code for commands.

### Horizontal Rules
Use `---` between every major H2 section. This creates visual breathing room and makes the doc scannable.

### Em-Dashes for Pivots
Use em-dashes to elaborate or pivot within a sentence:

```
What makes this significant isn't just the time saved — it's what the output looks like.
```

Not parentheses. Not a comma. The em-dash signals a meaningful contrast or addition.

---

## Sentence-Level Patterns

**Open sections with a declarative sentence that states the situation:**
- "Today, the Console QA team spends **3–5 hours per week** on manual release testing."
- "We currently lose an average of **38 Cerebras Code customers per week**."

**Use "Think of it as..." for analogies:**
- "Think of it as the difference between Claude with general knowledge and Claude that knows how your team works."

**Use "This creates an opportunity for..." to bridge problem → solution:**
- "This creates an opportunity for a different approach: using AI to generate and execute tests dynamically."

**Quantify compounding value, not just one-time savings:**
- "A skill that saves 30 minutes per use, used twice a week by a team of five, recovers ~130 hours per quarter. That compounds as more teams contribute."

**State what something is NOT before what it IS, when contrast clarifies:**
- "Claude Code is an AI agent that lives in your terminal and works like a capable engineer, not a line-by-line autocomplete."

**Name the recommendation before defending it:**
- "Option 2 (/skill-create) is the best available option today — it eliminates manual copy-paste and is the most guided experience."

---

## What NOT to Do

- **No executive filler.** Don't open with "In today's fast-paced environment..." or "This document aims to..."
- **No passive voice.** "We lose 38 customers per week" not "38 customers are lost per week."
- **No over-hedging.** "This could potentially maybe help reduce..." → "This reduces X."
- **No vague bullets.** Every bullet should carry a specific fact or action, not just a category name.
- **No long overviews that restate the title.** The first paragraph should add information, not repeat the heading.
- **No trailing summaries.** End with Next Steps or a → link, not "In conclusion, we have shown that..."
- **Never write "utilize" when "use" works.**

---

## Tone Calibration Examples

**Too formal / AI-sounding:**
> "This proposal outlines a strategic initiative designed to leverage artificial intelligence capabilities in order to optimize the quality assurance workflow and reduce operational overhead."

**Pearl's version:**
> "Today, the Console QA team spends 3–5 hours per week on manual release testing. AI can reduce that to minutes."

---

**Too vague:**
> "There are several options available, each with their own advantages and disadvantages, which we will explore below."

**Pearl's version:**
> "We're deciding how contributors should submit new skills. Three options exist — one is already built, one needs to be built, and one is manual. Here's what each solves and what it doesn't."

---

**Too hedged:**
> "It's possible that this approach might potentially help address some of the churn issues we've been seeing."

**Pearl's version:**
> "This experiment pays for itself if we save 4 Pro subscriptions per month. Any retention beyond that is pure upside."

---

## Final Check Before Publishing

Before creating or updating the page, verify:

1. Does the first paragraph contain a real data point or a specific problem statement?
2. Is the recommendation stated clearly and early — not buried at the end?
3. Are comparison options in a table, not just prose paragraphs?
4. Does every bullet point have a specific fact, not just a label?
5. Does the doc end with Next Steps or a → link, not a summary?
6. Are all numbers bolded for scannability?
7. Is there a `---` between every major H2 section?
