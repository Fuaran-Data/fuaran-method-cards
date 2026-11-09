#Requires -Version 7.0
<#
.SYNOPSIS
    Publication-boundary sweep: this repository names nothing a reader outside it cannot see.

.DESCRIPTION
    This repository is public and Apache-2.0 from its first commit, and it is written inside a private
    body of work it must not describe: the consumers of the specification, the products and clients
    around them, the planning surface they are tracked on. "Written to a public standard" is a claim,
    and a claim without a check decays one convenient reference at a time, so the standard is a gate
    and it runs from the first commit.

    Every tracked file (`git ls-files` — exactly what a publication carries) and every commit message
    (which a publication carries too) is swept. Both are part of the verdict.

    Because the repository is public, the list of what it must not say cannot be written here in
    clear: it is held as SHA-256 digests of the lower-cased terms in `gates/banned-terms.sha256`. A
    token hits when its digest, or that of any of its dot- or hyphen-separated parts or prefixes, is
    in the list. Two generic patterns need no secrecy and are matched in clear: a work-item reference
    (a key, a hash sign and a number: it names a planning surface and resolves nowhere outside it) and an absolute
    path from a developer machine.

    The copyright holder named by LICENSE, NOTICE and the source headers is a legal entity a published
    package is required to name, so it is not on the list.

.PARAMETER SkipHistory
    Sweep the working tree only.

.EXAMPLE
    pwsh ./gates/check-publication-boundary.ps1
#>
[CmdletBinding()]
param(
    [switch] $SkipHistory
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$listPath = Join-Path $PSScriptRoot 'banned-terms.sha256'

$banned = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($line in [IO.File]::ReadAllLines($listPath)) {
    $t = $line.Trim()
    if ($t -and -not $t.StartsWith('#')) { [void] $banned.Add($t) }
}
if ($banned.Count -eq 0) { throw "$listPath holds no digests" }

$sha = [Security.Cryptography.SHA256]::Create()

function Get-Digest([string] $term) {
    $bytes = [Text.Encoding]::UTF8.GetBytes($term.ToLowerInvariant())
    ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace('-', '').ToLowerInvariant()
}

# Every form of a token that is checked: the token, each of its parts, and each prefix along its dots
# and along its hyphens — so `a.b.c` is checked as `a.b.c`, `a.b`, `a`, `b` and `c`.
function Get-Candidates([string] $token) {
    $t = $token.Trim('.', '-', '_').ToLowerInvariant()
    $set = [Collections.Generic.HashSet[string]]::new()
    if (-not $t) { return $set }
    [void] $set.Add($t)
    foreach ($part in ($t -split '[-._]')) { if ($part) { [void] $set.Add($part) } }
    $dots = $t -split '\.'
    for ($i = 1; $i -lt $dots.Length; $i++) { [void] $set.Add(($dots[0..($i - 1)] -join '.')) }
    $dashes = $t -split '-'
    for ($i = 1; $i -lt $dashes.Length; $i++) { [void] $set.Add(($dashes[0..($i - 1)] -join '-')) }
    return $set
}

$tokenRegex = [regex]::new('[A-Za-z0-9][A-Za-z0-9_.\-]*')
$clear = @(
    @{ Id = 'work-item-ref'; Regex = [regex]::new('(?<![\w#])[a-z][a-z0-9-]*#\d+\b', 'IgnoreCase')
        Why = 'a work-item reference: it names a planning surface and resolves nowhere outside it'
    }
    @{ Id = 'developer-path'; Regex = [regex]::new('[A-Za-z]:[\\/](repos|Users)[\\/]')
        Why = 'an absolute path from a developer machine'
    }
)

function Find-Hits([string] $where, [string[]] $lines) {
    $hits = [Collections.Generic.List[object]]::new()
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ([string]::IsNullOrWhiteSpace($line)) { continue }

        foreach ($m in $tokenRegex.Matches($line)) {
            foreach ($candidate in (Get-Candidates $m.Value)) {
                if ($banned.Contains((Get-Digest $candidate))) {
                    $hits.Add([pscustomobject]@{ Where = $where; Line = $i + 1; Id = 'banned-term'; Token = $m.Value
                            Why = 'a term of the private surroundings this repository must not name' })
                    break
                }
            }
        }

        foreach ($c in $clear) {
            foreach ($m in $c.Regex.Matches($line)) {
                $hits.Add([pscustomobject]@{ Where = $where; Line = $i + 1; Id = $c.Id; Token = $m.Value; Why = $c.Why })
            }
        }
    }
    return , $hits
}

$binaryExtensions = @('.png', '.jpg', '.jpeg', '.gif', '.ico', '.zip', '.gz', '.pdf', '.woff', '.woff2', '.ttf', '.eot', '.nupkg', '.dll', '.exe', '.pdb')

Push-Location $repoRoot
try {
    $tracked = @(& git ls-files)
    if ($LASTEXITCODE -ne 0) { throw "git ls-files failed in $repoRoot" }
    # Files added to the index but not yet committed are tracked too; files on disk and unstaged are not
    # published and are not swept.
    $hasHead = $false
    & git rev-parse --verify --quiet HEAD *> $null
    if ($LASTEXITCODE -eq 0) { $hasHead = $true }
    $global:LASTEXITCODE = 0
    $messages = @()
    if ($hasHead -and -not $SkipHistory) {
        $messages = @((& git log --format='%H%x1f%B%x1e') -join "`n" -split "`u{1e}" | Where-Object { $_.Trim() })
    }
}
finally {
    Pop-Location
}

$all = [Collections.Generic.List[object]]::new()
$scanned = 0
foreach ($rel in $tracked) {
    $ext = [IO.Path]::GetExtension($rel).ToLowerInvariant()
    if ($binaryExtensions -contains $ext) { continue }
    $full = Join-Path $repoRoot $rel
    if (-not (Test-Path -LiteralPath $full)) { continue }
    $scanned++
    foreach ($h in (Find-Hits $rel ([IO.File]::ReadAllLines($full)))) { $all.Add($h) }
}

$commitsSwept = 0
foreach ($c in $messages) {
    $parts = $c -split "`u{1f}", 2
    if ($parts.Count -lt 2) { continue }
    $commitsSwept++
    $short = $parts[0].Trim().Substring(0, 9)
    foreach ($h in (Find-Hits "commit $short" ($parts[1] -split "`n"))) { $all.Add($h) }
}

Write-Host ''
Write-Host '=== Publication boundary =====================================================' -ForegroundColor Cyan
Write-Host ("  $($banned.Count) hashed terms + $($clear.Count) clear patterns over $scanned tracked file(s) and $commitsSwept commit message(s).")

if ($all.Count -gt 0) {
    Write-Host "  VIOLATIONS ($($all.Count)):" -ForegroundColor Red
    foreach ($h in ($all | Sort-Object Where, Line)) {
        Write-Host ("    $($h.Where):$($h.Line): [$($h.Id)] $($h.Token)") -ForegroundColor Red
        Write-Host ("      $($h.Why)") -ForegroundColor DarkRed
    }
    Write-Host '  RESULT: FAILED. Remove the term; a commit message cannot be edited, so a hit there is' -ForegroundColor Red
    Write-Host '  fixed by rewriting the unpublished history before it is pushed.' -ForegroundColor Red
    Write-Host '==============================================================================' -ForegroundColor Cyan
    exit 1
}

Write-Host '  RESULT: clean.' -ForegroundColor Green
Write-Host '==============================================================================' -ForegroundColor Cyan
exit 0
