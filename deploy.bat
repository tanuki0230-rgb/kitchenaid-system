@echo off
chcp 65001 >nul
title Deploy - Dr.KitchenAid System
cd /d D:\Claude-system\kitchenaid-system

echo.
echo  =========================================
echo    Dr.KitchenAid  -  Deploy System
echo  =========================================
echo.

:: ---------- GitHub ----------
echo  [1/2] Push to GitHub...
git add -A
git diff --cached --quiet 2>nul
if errorlevel 1 (
    git commit -m "update"
    git push origin main
    if errorlevel 1 (
        echo  [!] GitHub: push ไม่สำเร็จ ตรวจสอบ internet
    ) else (
        echo  [OK] GitHub อัปเดตแล้ว
    )
) else (
    echo  [--] GitHub: ไม่มีไฟล์เปลี่ยนแปลง
)
echo.

:: ---------- NAS ----------
echo  [2/2] Copy ไป NAS...
robocopy "D:\Claude-system\kitchenaid-system" "\\192.168.1.143\Kitchenaid-Web" /MIR /XD .git /XF .gitignore README.md /NP /NFL /NDL /NJH /NJS >nul 2>&1
if errorlevel 8 (
    echo  [!] NAS: copy ไม่สำเร็จ ตรวจสอบ network หรือ NAS เปิดอยู่ไหม
) else (
    echo  [OK] NAS อัปเดตแล้ว
)
echo.

echo  =========================================
echo    เสร็จแล้วครับ!
echo  =========================================
echo.
pause
