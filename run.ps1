# fuaran-method-cards — "drop into the repo, run one command, the thing works".
#
# Stages: tool restore -> Fantomas -> build -> the Expecto suite (which holds the schema validation and
# the corpus byte-equality) -> the Fable leg (the library compiled for a browser host) -> the
# publication-boundary sweep (every tracked file and every commit message).
#
#   pwsh ./run.ps1                 full pass
#   pwsh ./run.ps1 -SkipFormat     skip the Fantomas pass
#   pwsh ./run.ps1 -SkipBuild      skip the build (implies a prior build)
#   pwsh ./run.ps1 -SkipTests      skip the Expecto suite
#   pwsh ./run.ps1 -SkipFable      skip the Fable leg
#   pwsh ./run.ps1 -SkipBoundary   skip the publication-boundary sweep
#Requires -Version 7.0
[CmdletBinding()]
param(
    [switch] $SkipFormat,
    [switch] $SkipBuild,
    [switch] $SkipTests,
    [switch] $SkipFable,
    [switch] $SkipBoundary
)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

# A stage that runs no native command must not inherit another stage's exit code, and the
# `global:` scope is what reaches the code a caller sees when this script is invoked with `&`.
$global:LASTEXITCODE = 0

$solution = 'Fuaran.MethodCards.slnx'
$library = 'src/Fuaran.MethodCards/Fuaran.MethodCards.fsproj'
$testProject = 'tests/Fuaran.MethodCards.Tests'

dotnet tool restore
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$global:LASTEXITCODE = 0
if (-not $SkipFormat) {
    dotnet fantomas src tests
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$global:LASTEXITCODE = 0
if (-not $SkipBuild) {
    dotnet build $solution --nologo
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$global:LASTEXITCODE = 0
if (-not $SkipTests) {
    # `--no-build` only when this run already built; otherwise let `dotnet run` build first.
    if ($SkipBuild) {
        dotnet run --project $testProject
    }
    else {
        dotnet run --project $testProject --no-build
    }
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$global:LASTEXITCODE = 0
if (-not $SkipFable) {
    # The prompt fragment and the validator run in a browser host, so the library must compile under
    # Fable. The output goes to an ignored directory and is checked, never kept.
    dotnet fable $library -o fable-out --noCache
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$global:LASTEXITCODE = 0
if (-not $SkipBoundary) {
    & (Join-Path $PSScriptRoot 'gates/check-publication-boundary.ps1')
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
