#!/usr/bin/env bash
# NITERUN approved skill bootstrap (macOS / Linux).
# Installs only the reviewed "find-skills" skill from the NITERUN fork.
set -euo pipefail
command -v node >/dev/null || { echo 'Node.js 22.20+ is required.' >&2; exit 1; }
command -v npx >/dev/null || { echo 'npx is required.' >&2; exit 1; }
node -e 'const [maj,min]=process.versions.node.split(".").map(Number); if(maj<22 || (maj===22 && min<20)){ console.error("Node.js 22.20+ is required."); process.exit(1); }'
export DISABLE_TELEMETRY=1
# Run outside this repo: npm may otherwise resolve its unbuilt local 'skills' package.
cd "$HOME"
npx --yes skills@1.7.4 add chaybuilds/skills \
  --skill find-skills --global \
  --agent claude-code --agent codex --agent opencode --agent openhands --yes
npx --yes skills@1.7.4 list --global
test -f "$HOME/.agents/skills/find-skills/SKILL.md"
printf 'NITERUN find-skills ready: %s\n' "$HOME/.agents/skills/find-skills/SKILL.md"
