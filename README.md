# Personal Skills

A minimal template for managing your own [Claude Code](https://claude.ai/code) skills.

Works standalone or alongside Cerebras team skills and agents. Does not modify
`~/.claude/settings.json`, hooks, or any Cerebras state.

---

## Clone and set up

```bash
# Fork this repo on GitHub, then:
git clone git@github-cerebras:pearlh-cerebras/personal-skills.git ~/personal-skills
cd ~/personal-skills
chmod +x setup.sh sync.sh test.sh
./setup.sh
./test.sh
```

`setup.sh` creates symlinks from `~/.claude/skills/<name>` into this repo.
Claude Code picks them up automatically — no restart needed.

---

## Add a skill

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

3. Install and verify:

```bash
./setup.sh        # creates the symlink
./test.sh         # validates frontmatter, symlinks, and name conflicts
```

4. Use it in Claude Code: `/my-skill-name`

### Rules

- `name` in frontmatter must **exactly match** the directory name
- Skill names must be unique — `test.sh` checks against Cerebras team skills and agents if present
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

The Cerebras session-start hook only removes *dangling* symlinks (broken targets),
so your personal symlinks survive every Cerebras sync as long as this repo is on disk.

If a new Cerebras skill ever takes the same name as one of yours, `test.sh` will
flag it. Rename your skill directory and update `name:` in its frontmatter to fix it.
