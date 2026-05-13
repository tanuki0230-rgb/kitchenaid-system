@echo off
cd /d D:\Claude-system\kitchenaid-system

echo.
echo  =========================================
echo    Dr.KitchenAid - Deploy System
echo  =========================================
echo.

:: --- GitHub ---
echo  [1/2] Pushing to GitHub...
git add -A
git status --porcelain > %TEMP%\gitstatus.txt
for %%A in (%TEMP%\gitstatus.txt) do if %%~zA==0 goto :nonasonly
git commit -m "update"
git push origin main
if %errorlevel%==0 (
    echo  [OK] GitHub updated
) else (
    echo  [!!] GitHub push FAILED - check internet
)
goto :copytnas

:nonasonly
echo  [--] GitHub: no changes

:copytnas
echo.

:: --- NAS ---
echo  [2/3] Copying files to NAS...
robocopy "D:\Claude-system\kitchenaid-system" "\\192.168.1.143\Kitchenaid-Web" /MIR /XD .git /XF .gitignore README.md deploy.bat /NP /NFL /NDL /NJH /NJS
if errorlevel 8 (
    echo  [!!] NAS copy FAILED - check network or NAS
) else (
    echo  [OK] NAS files updated
)

echo.

:: --- Cloudflare KV Data Backup ---
echo  [3/3] Backing up Cloudflare KV data to NAS...
powershell -NoProfile -Command "$wc=New-Object System.Net.WebClient;$wc.Headers.Add('X-API-Key','ka-secret-999');$bytes=$wc.DownloadData('https://kitchenaid-messenger.dr-kicthenaid.workers.dev/export');$ts=Get-Date -Format 'yyyyMMdd_HHmmss';$folder='\\192.168.1.143\Kitchenaid-Web\backup-data';if(!(Test-Path $folder)){New-Item -ItemType Directory -Path $folder -Force|Out-Null};[System.IO.File]::WriteAllBytes(\"$folder\ka-data-$ts.json\",$bytes);Copy-Item \"$folder\ka-data-$ts.json\" \"$folder\ka-data-latest.json\" -Force;Write-Host '  [OK] KV backup saved: ka-data-'$ts'.json'"
if %errorlevel%==0 (
    echo  [OK] KV data backed up
) else (
    echo  [!!] KV backup FAILED - check internet
)

echo.
echo  =========================================
echo    Done!
echo  =========================================
echo.
