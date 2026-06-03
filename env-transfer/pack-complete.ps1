# Claude Code Complete Backup Script
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupDir = "$env:TEMP\claude-backup"
$zipPath = "$env:USERPROFILE\Desktop\claude-complete-$timestamp.zip"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Claude Code Complete Packer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Clean old backup
if (Test-Path $backupDir) {
    Remove-Item -Path $backupDir -Recurse -Force
}

# Create directory structure
Write-Host "[1/4] Creating directory structure..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
New-Item -ItemType Directory -Path "$backupDir\skills" -Force | Out-Null
New-Item -ItemType Directory -Path "$backupDir\plugins" -Force | Out-Null
New-Item -ItemType Directory -Path "$backupDir\marketplaces" -Force | Out-Null

# Copy Skills
Write-Host "[2/4] Copying Skills (27 items)..." -ForegroundColor Yellow
Copy-Item -Path "$env:USERPROFILE\.claude\skills\*" -Destination "$backupDir\skills" -Recurse -Force
$skillCount = (Get-ChildItem "$backupDir\skills" -Directory).Count
Write-Host "  Done: $skillCount skills copied" -ForegroundColor Gray

# Copy Plugin cache (actual plugin files)
Write-Host "[3/4] Copying Plugin cache..." -ForegroundColor Yellow
$pluginSources = @("claude-plugins-official", "karpathy-skills", "ppt-master")
foreach ($src in $pluginSources) {
    $srcPath = "$env:USERPROFILE\.claude\plugins\cache\$src"
    if (Test-Path $srcPath) {
        Copy-Item -Path $srcPath -Destination "$backupDir\plugins\$src" -Recurse -Force
        Write-Host "  Copied: $src" -ForegroundColor Gray
    }
}

# Copy installed_plugins.json
Copy-Item -Path "$env:USERPROFILE\.claude\plugins\installed_plugins.json" -Destination "$backupDir\plugins" -Force

# Copy marketplace directories
foreach ($marketplace in @("claude-plugins-official", "karpathy-skills")) {
    $mpPath = "$env:USERPROFILE\.claude\plugins\marketplaces\$marketplace"
    if (Test-Path $mpPath) {
        Copy-Item -Path $mpPath -Destination "$backupDir\marketplaces\$marketplace" -Recurse -Force
        Write-Host "  Copied marketplace: $marketplace" -ForegroundColor Gray
    }
}

# Create zip
Write-Host "[4/4] Creating zip archive..." -ForegroundColor Yellow
if (Test-Path $zipPath) {
    Remove-Item -Path $zipPath -Force
}
Compress-Archive -Path $backupDir -DestinationPath $zipPath -Force

# Cleanup temp
Remove-Item -Path $backupDir -Recurse -Force

# Get size
$zipSize = [math]::Round((Get-Item $zipPath).Length / 1MB, 1)

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Backup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "File: $zipPath" -ForegroundColor Cyan
Write-Host "Size: $zipSize MB" -ForegroundColor Cyan
Write-Host ""
