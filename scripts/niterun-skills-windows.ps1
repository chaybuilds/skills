# NITERUN approved skill bootstrap (Windows)
# Installs only the reviewed "find-skills" skill from the NITERUN fork.
$ErrorActionPreference = 'Stop'
$minimum = [version]'22.20.0'
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw 'Node.js 22.20+ is required.' }
if (-not (Get-Command npx -ErrorAction SilentlyContinue)) { throw 'npx is required.' }
$current = [version]((& node --version).Trim().TrimStart('v'))
if ($current -lt $minimum) { throw "Node.js $minimum or newer is required; found $current." }
$env:DISABLE_TELEMETRY = '1'
$cli = 'skills@1.7.4'
$source = 'chaybuilds/skills'
$agents = @('claude-code', 'codex', 'opencode', 'openhands')
$cliArgs = @('--yes', $cli, 'add', $source, '--skill', 'find-skills', '--global')
foreach ($agent in $agents) { $cliArgs += @('--agent', $agent) }
$cliArgs += '--yes'
# Run outside this repo: npm may otherwise resolve its unbuilt local 'skills' package.
Push-Location $HOME
try {
  & npx @cliArgs
  if ($LASTEXITCODE -ne 0) { throw 'NITERUN skill installation failed.' }
  & npx --yes $cli list --global
  if ($LASTEXITCODE -ne 0) { throw 'NITERUN skill verification failed.' }
} finally {
  Pop-Location
}
$entry = Join-Path $HOME '.agents\skills\find-skills\SKILL.md'
if (-not (Test-Path $entry)) { throw "Skill entrypoint missing: $entry" }
Write-Output "NITERUN find-skills ready: $entry"
