param(
    [string]$ApkPath = "build/app/outputs/flutter-apk/app-release.apk",
    [string]$NdkVersion = "",
    [string]$ReadElfPath = ""
)

$ErrorActionPreference = "Stop"
$MinimumAlign = 0x4000

function Get-RepoRoot {
    return (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

function Get-AndroidSdkDir {
    param([string]$RepoRoot)

    $localProperties = Join-Path $RepoRoot "android/local.properties"
    if (-not (Test-Path $localProperties)) {
        return $null
    }

    $sdkLine = Select-String -Path $localProperties -Pattern '^sdk\.dir\s*=\s*(.+)$' | Select-Object -First 1
    if (-not $sdkLine) {
        return $null
    }

    $rawValue = $sdkLine.Matches[0].Groups[1].Value.Trim()
    # local.properties escapes backslashes and sometimes colon.
    $unescaped = $rawValue -replace '\\\\', '\' -replace '\\:', ':'
    return $unescaped
}

function Get-NdkVersionFromGradle {
    param([string]$RepoRoot)

    $gradlePath = Join-Path $RepoRoot "android/app/build.gradle"
    if (-not (Test-Path $gradlePath)) {
        return $null
    }

    $match = Select-String -Path $gradlePath -Pattern 'ndkVersion\s*=\s*"([^"]+)"' | Select-Object -First 1
    if (-not $match) {
        return $null
    }

    return $match.Matches[0].Groups[1].Value.Trim()
}

function Resolve-ReadElf {
    param(
        [string]$RepoRoot,
        [string]$ProvidedReadElfPath,
        [string]$ProvidedNdkVersion
    )

    if ($ProvidedReadElfPath -and (Test-Path $ProvidedReadElfPath)) {
        return (Resolve-Path $ProvidedReadElfPath).Path
    }

    $ndkVersion = $ProvidedNdkVersion
    if (-not $ndkVersion) {
        $ndkVersion = Get-NdkVersionFromGradle -RepoRoot $RepoRoot
    }

    $sdkDir = Get-AndroidSdkDir -RepoRoot $RepoRoot
    if (-not $sdkDir -or -not $ndkVersion) {
        return $null
    }

    $candidate = Join-Path $sdkDir "ndk/$ndkVersion/toolchains/llvm/prebuilt/windows-x86_64/bin/llvm-readelf.exe"
    if (Test-Path $candidate) {
        return $candidate
    }

    return $null
}

function Convert-HexToInt64 {
    param([string]$Hex)
    $value = $Hex.Trim().ToLowerInvariant()
    if ($value.StartsWith("0x")) {
        $value = $value.Substring(2)
    }
    return [Convert]::ToInt64($value, 16)
}

$repoRoot = Get-RepoRoot
$resolvedApkPath = Join-Path $repoRoot $ApkPath
if (-not (Test-Path $resolvedApkPath)) {
    Write-Error "APK not found: $resolvedApkPath"
}

$readElf = Resolve-ReadElf -RepoRoot $repoRoot -ProvidedReadElfPath $ReadElfPath -ProvidedNdkVersion $NdkVersion
if (-not $readElf) {
    Write-Error "Could not locate llvm-readelf.exe. Provide -ReadElfPath or ensure android/local.properties and ndkVersion are set."
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($resolvedApkPath)
$tempDir = Join-Path $env:TEMP ("apk_16kb_check_" + [guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $tempDir | Out-Null

$rows = @()
$failed = @()

try {
    $arm64Entries = $zip.Entries | Where-Object { $_.FullName -like "lib/arm64-v8a/*.so" }
    if (-not $arm64Entries) {
        Write-Error "No arm64 libraries found in APK."
    }

    foreach ($entry in $arm64Entries) {
        $targetPath = Join-Path $tempDir $entry.FullName
        New-Item -ItemType Directory -Path (Split-Path $targetPath) -Force | Out-Null

        $entryStream = $entry.Open()
        $fileStream = [System.IO.File]::Create($targetPath)
        $entryStream.CopyTo($fileStream)
        $fileStream.Dispose()
        $entryStream.Dispose()

        $readElfOutput = & $readElf -l $targetPath
        $loadLines = $readElfOutput | Select-String "LOAD"

        if (-not $loadLines) {
            $failed += $entry.FullName
            $rows += [PSCustomObject]@{
                Library = $entry.FullName
                MinAlign = "N/A"
                Result  = "FAIL"
            }
            continue
        }

        $alignValues = @()
        foreach ($line in $loadLines) {
            $tokens = ($line.ToString() -split '\s+') | Where-Object { $_ }
            $alignToken = $tokens[-1]
            if ($alignToken -match '^0x[0-9a-fA-F]+$') {
                $alignValues += (Convert-HexToInt64 -Hex $alignToken)
            }
        }

        if (-not $alignValues) {
            $failed += $entry.FullName
            $rows += [PSCustomObject]@{
                Library = $entry.FullName
                MinAlign = "N/A"
                Result  = "FAIL"
            }
            continue
        }

        $minAlign = [Int64](($alignValues | Measure-Object -Minimum).Minimum)
        $isOk = $minAlign -ge $MinimumAlign

        $rows += [PSCustomObject]@{
            Library = $entry.FullName
            MinAlign = ('0x{0:X}' -f $minAlign)
            Result  = $(if ($isOk) { "PASS" } else { "FAIL" })
        }

        if (-not $isOk) {
            $failed += $entry.FullName
        }
    }
}
finally {
    $zip.Dispose()
    if (Test-Path $tempDir) {
        Remove-Item -Recurse -Force $tempDir
    }
}

$rows | Format-Table -AutoSize | Out-String | Write-Output

if ($failed.Count -gt 0) {
    Write-Output "16KB CHECK: FAIL"
    Write-Output "Libraries below required alignment (0x4000):"
    $failed | ForEach-Object { Write-Output "- $_" }
    exit 2
}

Write-Output "16KB CHECK: PASS"
exit 0
