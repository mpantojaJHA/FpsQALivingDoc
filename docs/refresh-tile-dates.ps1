param(
    [string]$IndexPath = "index.html",
    [switch]$Apply
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$resolvedIndexPath = Join-Path $repoRoot $IndexPath

if (-not (Test-Path $resolvedIndexPath)) {
    throw "Index file not found: $resolvedIndexPath"
}

$indexContent = Get-Content -Path $resolvedIndexPath -Raw -Encoding UTF8
$tilePattern = '<a(?=[^>]*\bclass="[^"]*\bbtn\b[^"]*")(?=[^>]*\bhref="(?<href>[^"]+)")[^>]*>'

$updatedTileTags = New-Object System.Collections.Generic.List[string]

$updatedContent = [regex]::Replace($indexContent, $tilePattern, {
    param($match)

    $tileTag = $match.Value
    $href = $match.Groups['href'].Value
    $linkedFile = Join-Path $repoRoot $href

    if (-not (Test-Path $linkedFile)) {
        return $tileTag
    }

    $updatedDate = (Get-Item $linkedFile).LastWriteTime.ToString('yyyy-MM-dd')

    if ($tileTag -match 'data-updated="[^"]*"') {
        $replacement = 'data-updated="{0}"' -f $updatedDate
        $newTileTag = [regex]::Replace($tileTag, 'data-updated="[^"]*"', $replacement, 1)
    } else {
        $newTileTag = $tileTag -replace '>$', (' data-updated="{0}">' -f $updatedDate)
    }

    $updatedTileTags.Add($newTileTag) | Out-Null
    return $newTileTag
}, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

if ($updatedTileTags.Count -eq 0) {
    Write-Output "No tiles were matched in $IndexPath."
    exit 0
}

if ($Apply) {
    Set-Content -Path $resolvedIndexPath -Value $updatedContent -Encoding UTF8
    Write-Output "Updated tile dates in $IndexPath"
} else {
    Write-Output "Preview of updated tile opening tags (paste as needed):"
    $updatedTileTags | ForEach-Object { Write-Output $_ }
    Write-Output ""
    Write-Output "Tip: run with -Apply to update $IndexPath automatically."
}