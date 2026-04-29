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
echo  [2/2] Copying to NAS...
robocopy "D:\Claude-system\kitchenaid-system" "\\192.168.1.143\Kitchenaid-Web" /MIR /XD .git /XF .gitignore README.md deploy.bat /NP /NFL /NDL /NJH /NJS
if errorlevel 8 (
    echo  [!!] NAS copy FAILED - check network or NAS
) else (
    echo  [OK] NAS updated
)

echo.
echo  =========================================
echo    Done!
echo  =========================================
echo.
pause
