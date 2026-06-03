@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo Claude Code Environment Installer
echo ========================================
echo.

set "CLAUDE_DIR=%USERPROFILE%\.claude"
set "SCRIPT_DIR=%~dp0"

:: Create .claude directory if not exists
if not exist "%CLAUDE_DIR%" mkdir "%CLAUDE_DIR%"

:: Step 1: Copy Skills
echo [1/4] Installing Skills...
if not exist "%CLAUDE_DIR%\skills" mkdir "%CLAUDE_DIR%\skills"
xcopy /E /I /Y "%SCRIPT_DIR%claude-backup\skills\*" "%CLAUDE_DIR%\skills\" >nul
echo   Skills installed successfully

:: Step 2: Copy Plugin cache
echo [2/4] Installing Plugins...
if not exist "%CLAUDE_DIR%\plugins\cache" mkdir "%CLAUDE_DIR%\plugins\cache"
xcopy /E /I /Y "%SCRIPT_DIR%claude-backup\plugins\claude-plugins-official" "%CLAUDE_DIR%\plugins\cache\claude-plugins-official\" >nul
xcopy /E /I /Y "%SCRIPT_DIR%claude-backup\plugins\karpathy-skills" "%CLAUDE_DIR%\plugins\cache\karpathy-skills\" >nul
xcopy /E /I /Y "%SCRIPT_DIR%claude-backup\plugins\ppt-master" "%CLAUDE_DIR%\plugins\cache\ppt-master\" >nul
echo   Plugin files copied

:: Step 3: Copy Marketplaces
echo [3/4] Installing Marketplaces...
if not exist "%CLAUDE_DIR%\plugins\marketplaces" mkdir "%CLAUDE_DIR%\plugins\marketplaces"
if exist "%SCRIPT_DIR%claude-backup\marketplaces\claude-plugins-official" (
    xcopy /E /I /Y "%SCRIPT_DIR%claude-backup\marketplaces\claude-plugins-official" "%CLAUDE_DIR%\plugins\marketplaces\claude-plugins-official\" >nul
)
if exist "%SCRIPT_DIR%claude-backup\marketplaces\karpathy-skills" (
    xcopy /E /I /Y "%SCRIPT_DIR%claude-backup\marketplaces\karpathy-skills" "%CLAUDE_DIR%\plugins\marketplaces\karpathy-skills\" >nul
)
echo   Marketplaces installed

:: Step 4: Update installed_plugins.json paths
echo [4/4] Updating plugin configuration...

:: Generate new installed_plugins.json with correct paths
(
echo {
echo   "version": 2,
echo   "plugins": {
echo     "frontend-design@claude-plugins-official": [
echo       {
echo         "scope": "user",
echo         "installPath": "%USERPROFILE:\=\\%\\.claude\\plugins\\cache\\claude-plugins-official\\frontend-design\\1d9326322381",
echo         "version": "1d9326322381",
echo         "installedAt": "2026-06-02T09:21:50.653Z",
echo         "lastUpdated": "2026-06-03T14:40:09.392Z",
echo         "gitCommitSha": "1d93263223815e0793831645843e0d72d9ed541b"
echo       }
echo     ],
echo     "desktop-commander@claude-plugins-official": [
echo       {
echo         "scope": "user",
echo         "installPath": "%USERPROFILE:\=\\%\\.claude\\plugins\\cache\\claude-plugins-official\\desktop-commander\\ce4669cca7a0-53b37853",
echo         "version": "ce4669cca7a0-53b37853",
echo         "installedAt": "2026-06-02T09:25:05.044Z",
echo         "lastUpdated": "2026-06-03T05:16:50.959Z",
echo         "gitCommitSha": "ce4669cca7a07bd5d493cedb01df400790ec9e23"
echo       }
echo     ],
echo     "andrej-karpathy-skills@karpathy-skills": [
echo       {
echo         "scope": "user",
echo         "installPath": "%USERPROFILE:\=\\%\\.claude\\plugins\\cache\\karpathy-skills\\andrej-karpathy-skills\\1.0.0",
echo         "version": "1.0.0",
echo         "installedAt": "2026-06-02T12:00:21.533Z",
echo         "lastUpdated": "2026-06-02T12:00:21.533Z",
echo         "gitCommitSha": "2c606141936f1eeef17fa3043a72095b4765b9c2"
echo       }
echo     ],
echo     "superpowers@claude-plugins-official": [
echo       {
echo         "scope": "user",
echo         "installPath": "%USERPROFILE:\=\\%\\.claude\\plugins\\cache\\claude-plugins-official\\superpowers\\5.1.0",
echo         "version": "5.1.0",
echo         "installedAt": "2026-06-02T13:31:58.474Z",
echo         "lastUpdated": "2026-06-02T13:31:58.474Z",
echo         "gitCommitSha": "f2cbfbefebbfef77321e4c9abc9e949826bea9d7"
echo       }
echo     ],
echo     "ppt-master@ppt-master": [
echo       {
echo         "scope": "user",
echo         "installPath": "%USERPROFILE:\=\\%\\.claude\\plugins\\cache\\ppt-master\\ppt-master\\2.7.0",
echo         "version": "2.7.0",
echo         "installedAt": "2026-06-03T15:22:00.000Z",
echo         "lastUpdated": "2026-06-03T15:22:00.000Z",
echo         "gitCommitSha": "328388d4e76778535676056f49be8f28a08e79b2"
echo       }
echo     ]
echo   }
echo }
) > "%CLAUDE_DIR%\plugins\installed_plugins.json"

echo   Configuration updated with correct paths

:: Generate known_marketplaces.json
(
echo {
echo   "claude-plugins-official": {
echo     "source": {
echo       "source": "github",
echo       "repo": "anthropics/claude-plugins-official"
echo     },
echo     "installLocation": "%USERPROFILE:\=\\%\\.claude\\plugins\\marketplaces\\claude-plugins-official",
echo     "lastUpdated": "2026-06-03T16:13:44.056Z"
echo   },
echo   "karpathy-skills": {
echo     "source": {
echo       "source": "github",
echo       "repo": "forrestchang/andrej-karpathy-skills"
echo     },
echo     "installLocation": "%USERPROFILE:\=\\%\\.claude\\plugins\\marketplaces\\karpathy-skills",
echo     "lastUpdated": "2026-06-02T12:00:08.474Z"
echo   },
echo   "ppt-master": {
echo     "source": {
echo       "source": "github",
echo       "repo": "hugohe3/ppt-master"
echo     },
echo     "installLocation": "%USERPROFILE:\=\\%\\ppt-master",
echo     "lastUpdated": "2026-06-03T15:20:00.000Z"
echo   }
echo }
) > "%CLAUDE_DIR%\plugins\known_marketplaces.json"

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo Please restart VSCode to apply changes.
echo.
pause
