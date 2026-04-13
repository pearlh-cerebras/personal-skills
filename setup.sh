#!/bin/bash
# Personal Skills Setup
# Creates symlinks from ~/.claude/skills/<name> → <this-repo>/skills/<name>
#
# Usage:
#   ./setup.sh          — install all skills in skills/
#   ./setup.sh --help   — show this message
#
# Safe to re-run. Does not modify ~/.claude/settings.json or any Cerebras
# state. Will warn and skip any skill name that conflicts with a Cerebras
# team skill or an agents sidecar skill.

set -euo pipefail

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    sed -n '2,12p' "$0" | sed 's/^# \?//'
    exit 0
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="$REPO_DIR/skills"
SKILLS_DEST="$HOME/.claude/skills"

# ── Gather reserved names ──────────────────────────────────────────────────
reserved=()

# Cerebras team skills
CEREBRAS_REGISTRY="$HOME/.claude/cerebras-skills-repo/registry.json"
if [[ -f "$CEREBRAS_REGISTRY" ]]; then
    while IFS= read -r name; do
        reserved+=("$name")
    done < <(jq -r '.skills | keys[]' "$CEREBRAS_REGISTRY" 2>/dev/null)
fi

# Agents sidecar skills
agents_cache="${CEREBRAS_AGENTS_CACHE_DIR:-$HOME/ws/.cerebras/agents}"
for profile_path in \
    "$agents_cache/.sidecar-profile.json" \
    "$HOME/.agents/.sidecar-profile.json" \
    "$HOME"/*/.agents/.sidecar-profile.json \
    "$HOME"/*/*/.agents/.sidecar-profile.json; do
    [[ -f "$profile_path" ]] || continue
    while IFS= read -r name; do
        reserved+=("$name")
    done < <(jq -r '(.visible_skills[]?.name // empty), (.external_skills[]?.name // empty)' \
        "$profile_path" 2>/dev/null)
done

is_reserved() {
    local name="$1"
    for r in "${reserved[@]:-}"; do
        [[ "$r" == "$name" ]] && return 0
    done
    return 1
}

# ── Install skills ─────────────────────────────────────────────────────────
mkdir -p "$SKILLS_DEST"
installed=0
skipped=0

echo "Installing personal skills from $REPO_DIR..."
echo ""

for skill_dir in "$SKILLS_SOURCE"/*/; do
    [[ -d "$skill_dir" ]] || continue
    skill_name="$(basename "$skill_dir")"
    skill_md="$skill_dir/SKILL.md"

    # Must have SKILL.md
    if [[ ! -f "$skill_md" ]]; then
        echo "  SKIP  $skill_name  (no SKILL.md found)"
        ((skipped++)) || true
        continue
    fi

    # Must not conflict with Cerebras or agents
    if is_reserved "$skill_name"; then
        echo "  SKIP  $skill_name  (name conflicts with a Cerebras/agents skill — rename it)"
        ((skipped++)) || true
        continue
    fi

    # Must not overwrite a real (non-symlink) directory
    if [[ -e "$SKILLS_DEST/$skill_name" && ! -L "$SKILLS_DEST/$skill_name" ]]; then
        echo "  SKIP  $skill_name  ($SKILLS_DEST/$skill_name is a real directory — remove it manually)"
        ((skipped++)) || true
        continue
    fi

    ln -sfn "$skill_dir" "$SKILLS_DEST/$skill_name"
    echo "  OK    $skill_name"
    ((installed++)) || true
done

echo ""
echo "Done: $installed installed, $skipped skipped."
echo ""
echo "Run './test.sh' to verify, then start 'claude' to use your skills."
