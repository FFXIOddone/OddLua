@echo off
setlocal
set "ROOT=%~dp0"
set "LOGDIR=%ROOT%reports\game-refresh"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"
cd /d "%ROOT%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%ROOT%Run-OddLuaGameRefresh.ps1" >> "%LOGDIR%\launcher.log" 2>&1
exit /b %ERRORLEVEL%
