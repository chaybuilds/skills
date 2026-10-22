# NITERUN CLI runner: avoids the Node 24 Windows/libuv shutdown error.
# Usage: .\scripts\niterun-skill-cli.ps1 find "typescript testing"
param([Parameter(ValueFromRemainingArguments = $true)][string[]]$CliArguments)
$ErrorActionPreference = 'Stop'
if (-not $CliArguments -or $CliArguments.Count -eq 0) { throw 'Supply a skills CLI command (e.g. find "react testing").' }
$repo = Split-Path -Parent $PSScriptRoot
$cliFile = Join-Path $repo 'bin\cli.mjs'
$distFile = Join-Path $repo 'dist\cli.mjs'
if (-not (Test-Path $distFile)) { throw 'Build cloned CLI first: corepack pnpm install --frozen-lockfile --ignore-scripts; corepack pnpm exec obuild' }
$nodeExe = Join-Path $env:LOCALAPPDATA 'NITERUN\runtimes\node-v22.23.4\node.exe'
if (Test-Path $nodeExe) {
  $expected = 'dccc52de28d8df2ee22d2062424f8c563070d95d8ad70c54c4bf01d590dec14f'
  if ((Get-FileHash $nodeExe -Algorithm SHA256).Hash.ToLowerInvariant() -ne $expected) { throw 'Node runtime checksum mismatch.' }
} else {
  $nodeExe = (Get-Command node -ErrorAction Stop).Source
  $version = [version]((& $nodeExe --version).Trim().TrimStart('v'))
  if ($version.Major -ge 24) { throw 'Windows Node 24 may crash on skill discovery. Run scripts/niterun-skills-windows.ps1 to install a safe isolated runtime.' }
}
$env:DISABLE_TELEMETRY = '1'
Push-Location $HOME
try {
  & $nodeExe $cliFile @CliArguments
  if ($LASTEXITCODE -ne 0) { throw "Skills CLI failed with exit code $LASTEXITCODE" }
} finally {
  Pop-Location
}
