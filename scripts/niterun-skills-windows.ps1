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
# Node 24+ on Windows may abort on exit from "skills find" (libuv).
# Install an isolated, SHA256-verified Node 22 runtime without changing system Node.
if ($current.Major -ge 24) {
  $runtimeDir = Join-Path $env:LOCALAPPDATA 'NITERUN\runtimes\node-v22.23.4'
  $nodeExe = Join-Path $runtimeDir 'node.exe'
  $expected = 'dccc52de28d8df2ee22d2062424f8c563070d95d8ad70c54c4bf01d590dec14f'
  New-Item -ItemType Directory -Path $runtimeDir -Force | Out-Null
  if (-not (Test-Path $nodeExe)) {
    $tempExe = Join-Path $runtimeDir 'node.download.exe'
    try {
      Invoke-WebRequest -Uri 'https://nodejs.org/dist/v22.23.4/win-x64/node.exe' -OutFile $tempExe -UseBasicParsing
      if ((Get-FileHash $tempExe -Algorithm SHA256).Hash.ToLowerInvariant() -ne $expected) { throw 'Node 22 download checksum mismatch.' }
      Move-Item -LiteralPath $tempExe -Destination $nodeExe -Force
    } finally {
      if (Test-Path $tempExe) { Remove-Item -LiteralPath $tempExe -Force }
    }
  }
  if ((Get-FileHash $nodeExe -Algorithm SHA256).Hash.ToLowerInvariant() -ne $expected) { throw 'Node 22 runtime checksum mismatch.' }
  Write-Output 'Verified isolated Node 22 runtime for Windows skill discovery.'
}
Write-Output "NITERUN find-skills ready: $entry"
