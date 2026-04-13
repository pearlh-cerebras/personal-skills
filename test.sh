#!/bin/bash
# Personal Skills Test
# Validates that all personal skills are correctly installed and won't
# interfere with Cerebras team skills or agents sidecar skills.
#
# Usage: ./test.sh

set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="$REPO_DIR/skills"
SKILLS_DEST="$HOME/.claude/skills"
CEREBRAS_REGISTRY="$HOME/.claude/cerebras-skills-repo/registry.json"

pass=0
warn=0
fail=0

ok()   { echo "  PASS  $*"; ((pass++)) || true; }
warn() { echo "  WARN  $*"; ((warn++)) || true; }
fail() { echo "  FAIL  $*"; ((fail++)) || true; }

# ── Gather reserved names ──────────────────────────────────────────────────
cerebras_names=()
if [[ -f "$CEREBRAS_REGISTRY" ]]; then
    while IFS= read -r name; do
        cerebras_names+=("$name")
    done < <(jq -r '.skills | keys[]' "$CEREBRAS_REGISTRY" 2>/dev/null)
fi

agents_names=()
agents_cache="${CEREBRAS_AGENTS_CACHE_DIR:-$HOME/ws/.cerebras/agents}"
for profile_path in \
    "$agents_cache/.sidecar-profile.json" \
    "$HOME/.agents/.sidecar-profile.json" \
    "$HOME"/*/.agents/.sidecar-profile.json \
    "$HOME"/*/*/.agents/.sidecar-profile.json; do
    [[ -f "$profile_path" ]] || continue
    while IFS= read -r name; do
        agents_names+=("$name")
    done < <(jq -r '(.visible_skills[]?.name // empty), (.external_skills[]?.name // empty)' \
        "$profile_path" 2>/dev/null)
done

in_list() {
    local needle="$1"; shift
    local item
    for item in "$@"; do
        [[ "$item" == "$needle" ]] && return 0
    done
    return 1
}

# ── Check prerequisites ────────────────────────────────────────────────────
echo ""
echo "── Prerequisites ─────────────────────────────────────────────────────"

if [[ -d "$SKILLS_DEST" ]]; then
    ok "~/.claude/skills/ exists"
else
    fail "~/.claude/skills/ does not exist — run setup.sh first"
fi

if command -v jq &>/dev/null; then
    ok "jq is available"
else
    warn "jq not found — conflict checks skipped (brew install jq)"
fi

if [[ -f "$CEREBRAS_REGISTRY" ]]; then
    cerebras_count="${#cerebras_names[@]}"
    ok "Cerebras registry found ($cerebras_count team skills checked for conflicts)"
else
    ok "No Cerebras registry — conflict checks not applicable"
fi

if [[ ${#agents_names[@]} -gt 0 ]]; then
    ok "Agents sidecar found (${#agents_names[@]} agent skills checked for conflicts)"
else
    ok "No agents sidecar — conflict checks not applicable"
fi

# ── Validate each skill in the repo ───────────────────────────────────────
echo ""
echo "── Skill validation ──────────────────────────────────────────────────"

skill_count=0
for skill_dir in "$SKILLS_SOURCE"/*/; do
    [[ -d "$skill_dir" ]] || continue
    skill_name="$(basename "$skill_dir")"
    ((skill_count++)) || true

    echo ""
    echo "  Skill: $skill_name"

    # 1. SKILL.md exists
    skill_md="$skill_dir/SKILL.md"
    if [[ ! -f "$skill_md" ]]; then
        fail "$skill_name: SKILL.md not found"
        continue
    fi
    ok "$skill_name: SKILL.md exists"

    # 2. Frontmatter has required 'name' field
    fm_name=$(awk '/^---/{p++} p==1{print} p==2{exit}' "$skill_md" | grep '^name:' | sed 's/name: *//')
    if [[ -z "$fm_name" ]]; then
        fail "$skill_name: frontmatter missing 'name:' field"
    elif [[ "$fm_name" != "$skill_name" ]]; then
        fail "$skill_name: frontmatter name '$fm_name' does not match directory name '$skill_name'"
    else
        ok "$skill_name: frontmatter name matches directory"
    fi

    # 3. Frontmatter has 'description' field
    fm_desc=$(awk '/^---/{p++} p==1{print} p==2{exit}' "$skill_md" | grep '^description:' | sed 's/description: *//')
    if [[ -z "$fm_desc" ]]; then
        fail "$skill_name: frontmatter missing 'description:' field"
    else
        ok "$skill_name: frontmatter has description"
    fi

    # 4. No conflict with Cerebras skills
    if [[ ${#cerebras_names[@]} -gt 0 ]]; then
        if in_list "$skill_name" "${cerebras_names[@]}"; then
            fail "$skill_name: conflicts with a Cerebras team skill — choose a different name"
        else
            ok "$skill_name: no Cerebras name conflict"
        fi
    else
        ok "$skill_name: Cerebras conflict check — not applicable"
    fi

    # 5. No conflict with agents skills
    if [[ ${#agents_names[@]} -gt 0 ]]; then
        if in_list "$skill_name" "${agents_names[@]}"; then
            fail "$skill_name: conflicts with an agents sidecar skill — choose a different name"
        else
            ok "$skill_name: no agents name conflict"
        fi
    else
        ok "$skill_name: agents conflict check — not applicable"
    fi

    # 6. Symlink installed and valid
    link="$SKILLS_DEST/$skill_name"
    if [[ ! -e "$link" ]]; then
        fail "$skill_name: not installed at $link — run setup.sh"
    elif [[ -L "$link" ]]; then
        target="$(readlink "$link")"
        if [[ "$target" == "$skill_dir" || "$target" == "${skill_dir%/}" ]]; then
            ok "$skill_name: symlink installed and points to this repo"
        else
            warn "$skill_name: symlink exists but points elsewhere ($target)"
        fi
    else
        warn "$skill_name: $link is a real directory, not a symlink"
    fi

    # 7. SKILL.md is readable through the symlink (what Claude Code sees)
    if [[ -f "$link/SKILL.md" ]]; then
        ok "$skill_name: SKILL.md readable through symlink (Claude Code can load it)"
    else
        fail "$skill_name: SKILL.md not readable through symlink"
    fi
done

if [[ $skill_count -eq 0 ]]; then
    warn "No skills found in $SKILLS_SOURCE"
fi

# ── Check for orphaned symlinks pointing to this repo ─────────────────────
echo ""
echo "── Orphaned symlink check ────────────────────────────────────────────"
orphan_count=0
for link in "$SKILLS_DEST"/*/; do
    [[ -L "${link%/}" ]] || continue
    target="$(readlink "${link%/}")"
    # Is this symlink pointing into our repo?
    if [[ "$target" == "$SKILLS_SOURCE"/* ]] || [[ "$target" == "$REPO_DIR"/* ]]; then
        skill_name="$(basename "${link%/}")"
        if [[ ! -d "$SKILLS_SOURCE/$skill_name" ]]; then
            warn "Orphaned symlink: $skill_name points to this repo but skill was deleted — run setup.sh to clean up"
            ((orphan_count++)) || true
        fi
    fi
done
if [[ $orphan_count -eq 0 ]]; then
    ok "No orphaned symlinks"
fi

# ── Summary ────────────────────────────────────────────────────────────────
echo ""
echo "── Summary ───────────────────────────────────────────────────────────"
echo "  $skill_count skill(s) found  |  $pass passed  |  $warn warnings  |  $fail failed"
echo ""

if [[ $fail -gt 0 ]]; then
    echo "Fix the failures above, then re-run ./test.sh"
    exit 1
elif [[ $warn -gt 0 ]]; then
    echo "All skills installed. Review warnings above."
    exit 0
else
    echo "All skills installed and validated."
    exit 0
fi
