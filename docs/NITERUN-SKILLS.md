# NITERUN: shared agent skill discovery

**Upstream:** https://github.com/vercel-labs/skills
**Controlled fork:** https://github.com/chaybuilds/skills
**CLI:** `skills` v1.7.4; Node.js 22.20+ required
**Initial approved skill:** `find-skills` only

## Purpose

Give NITERUN engineering agents one discoverable, reviewed way to find relevant
reusable skills. Use *global* installation so supported agents can read the
same canonical instructions across local projects.

## Bootstrap new authorized workstations

Windows PowerShell:
```powershell
.\scripts\niterun-skills-windows.ps1
```

macOS / Linux:
```bash
bash scripts/niterun-skills-unix.sh
```

Both scripts install `find-skills` from `chaybuilds/skills` for Claude Code,
Codex, OpenCode and OpenHands. Global files live in
`~/.agents/skills/find-skills` with links for compatible agent directories.

## Use and verify

```sh
npx --yes skills@1.7.4 find "typescript testing"
npx --yes skills@1.7.4 list --global
npx --yes skills@1.7.4 check
```

Search **does not** install third-party skills. For every additional skill,
review `SKILL.md`, scripts, data/network access, provenance, license, and
permissions before installing. Do not enable unattended skill installation
or arbitrary code execution. Avoid automatically updating the fork without review.

## Rollout boundaries

Global installation shares skill instructions between compatible agents
**on that machine**, not with independent cloud services, model providers,
production apps, or ChatGPT's hosted skill library. Those environments need
separate integrations and authorization. This bootstrap does not install,
authenticate, or grant permissions to those independent systems.

The fork preserves Vercel's MIT license and remains linked to upstream.
Only merge upstream changes after review and test; avoid including secrets
or NITERUN private architecture in this public repository.

## Evidence

2026-10-22: The CLI source build, version check, and live skill search
were verified on an authorized Windows workstation. The reviewed
`find-skills` capability was installed globally on that Windows
workstation and on a connected macOS workstation.
Offline devices and independent cloud runtimes remain out of scope.
