# 1. Run Tests
Write-Host "Running Flutter Tests..." -ForegroundColor Cyan
flutter test --coverage
if ($LASTEXITCODE -ne 0) {
    Write-Host "Tests failed! Exiting." -ForegroundColor Red
    exit 1
}

# 2. Clean Generated Files (Pure PowerShell - No dependencies)
Write-Host "Cleaning generated files..." -ForegroundColor Yellow
$lcovFile = "coverage/lcov.info"

if (Test-Path $lcovFile) {
    $content = Get-Content $lcovFile
    $newContent = @()
    $skip = $false

    foreach ($line in $content) {
        if ($line.StartsWith("SF:")) {
            $path = $line.Substring(3)
            # Regex for generated files (Windows/Unix compatible)
            # Matches: .g.dart, .freezed.dart, .config.dart
            # Matches directories: lib/gen/, lib/core/l10n/, lib/l10n/
            # Matches files starting with app_localizations
            if ($path -match "\.g\.dart$" -or
                $path -match "\.freezed\.dart$" -or
                $path -match "\.config\.dart$" -or
                $path -match "firebase_module\.dart$" -or
                $path -match "firebase_options.dart" -or
                $path -match "lib[\\/]gen[\\/]" -or
                $path -match "lib[\\/]core[\\/]l10n[\\/]" -or
                $path -match "lib[\\/]l10n[\\/]" -or
                $path -match "app_localizations.*\.dart") {
                $skip = $true
            } else {
                $skip = $false
                $newContent += $line
            }
        } elseif (-not $skip) {
            $newContent += $line
        }
    }

    # Save cleaned content back to file
    $newContent | Set-Content $lcovFile -Encoding UTF8

    # 3. Calculate Percentage
    Write-Host "Calculating Coverage..." -ForegroundColor Cyan
    $totalLines = 0
    $coveredLines = 0

    foreach ($line in $newContent) {
        if ($line -match "^LF:(\d+)") { $totalLines += [int]$matches[1] }
        if ($line -match "^LH:(\d+)") { $coveredLines += [int]$matches[1] }
    }

    if ($totalLines -gt 0) {
        $percent = ($coveredLines / $totalLines) * 100
        $percentStr = "{0:N2}%" -f $percent

        Write-Host ""
        Write-Host "==========================================" -ForegroundColor Green
        Write-Host " FINAL TEST COVERAGE: $percentStr" -ForegroundColor Green
        Write-Host "==========================================" -ForegroundColor Green
        Write-Host "Upload coverage/lcov.info to: https://lcov-viewer.netlify.app/report" -ForegroundColor White
    } else {
        Write-Host "No coverage data available." -ForegroundColor Red
    }
} else {
    Write-Host "coverage/lcov.info not found!" -ForegroundColor Red
}
