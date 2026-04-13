# Personal Skills

A minimal template for managing your own [Claude Code](https://claude.ai/code) skills.

Works standalone or alongside Cerebras team skills and agents. Does not modify
`~/.claude/settings.json`, hooks, or any Cerebras state.

---

## Clone and set up

```bash
# Fork this repo on GitHub, then:
git clone git@github.com:pearlh-cerebras/personal-skills.git ~/personal-skills
cd ~/personal-skills
chmod +x setup.sh sync.sh test.sh
./setup.sh
./test.sh
```

`setup.sh` creates symlinks from `~/.claude/skills/<name>` into this repo.
Claude Code picks them up automatically — no restart needed.

---

## Add a skill

### With Claude (recommended)

Paste this into Claude Code, filling in the name and description:

```
Create a skill called `my-skill-name` that does X.
Save it to ~/personal-skills/skills/my-skill-name/SKILL.md,
run ./setup.sh to install it, run ./test.sh to validate,
then commit and push it to the personal-skills repo.
```

Claude will write the `SKILL.md`, install the symlink, validate, commit, and push.

> **Important:** include the `~/personal-skills/skills/` path explicitly. Without it,
> Claude may write directly to `~/.claude/skills/`, which isn't version controlled and
> can be silently overwritten by a Cerebras sync if names ever collide.

### Manually

1. Create a directory and `SKILL.md` inside it:

```
skills/
└── my-skill-name/
    └── SKILL.md
```

2. Write the skill file:

```markdown
---
name: my-skill-name
description: One sentence describing what this skill does (shown in the skills list).
---

# My Skill

What this skill does and when to use it.

---

## Step 1: ...

## Step 2: ...

## Output

What the user gets at the end.
```

3. Install, verify, and commit:

```bash
./setup.sh                          # creates the symlink
./test.sh                           # validates frontmatter, symlinks, and name conflicts
git add skills/my-skill-name/
git commit -m "Add my-skill-name skill"
git push
```

4. Use it in Claude Code: `/my-skill-name`

### Picking a name — check first

Cerebras team skills are symlinked into `~/.claude/skills/` at session start, so that
directory shows you all names that are taken:

```bash
ls ~/.claude/skills/
```

Or type `/` in Claude Code and browse the autocomplete list.

**`test.sh` also catches conflicts automatically** before installing.

### What happens if names collide with Cerebras

At the next session start, the Cerebras hook silently runs
`rm -rf ~/.claude/skills/<your-skill>` and replaces your symlink with its own. Your
files in this repo are untouched, but the skill stops working until you rename it and
re-run `./setup.sh`. No warning is given.

If you hit a collision after the fact, rename the skill directory, update `name:` in
its frontmatter to match, and re-run `./setup.sh`.

### Other rules

- `name` in frontmatter must **exactly match** the directory name
- Keep descriptions under 1024 characters; avoid angle brackets

---

## Update

```bash
./sync.sh    # git pull + refresh symlinks
```

---

## How it works

`setup.sh` symlinks each `skills/<name>/` directory into `~/.claude/skills/`.
Claude Code scans that directory at startup to discover skills.

Cerebras skills are symlinked into `~/.claude/skills/` from `cerebras-skills-repo`;
agents skills are injected separately and never touch `~/.claude/skills/`. Personal
skill symlinks with unique names survive every Cerebras sync — the hook only clobbers
entries whose names match something in the Cerebras registry.
