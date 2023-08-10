@echo off
REM Unattended option minimizes the window and doesn't pause
if "%1" NEQ "unattended" goto :nonircmdc
where /q nircmdc.exe
if ERRORLEVEL 1 GOTO nonircmdc
nircmdc.exe win min foreground
:nonircmdc

echo This will LZX compress everything in Windows 10. Hit CTRL+C to abort.
echo WINDIR = %WINDIR%
echo ProgramFiles(x86) = %ProgramFiles(x86)%
echo ProgramFiles = %ProgramFiles%
echo ProgramW6432 = %ProgramW6432%
echo ProgramData = %ProgramData
if "%1" NEQ "unattended" pause

REM Windows/System32/SysWOW64 (MUST NOT COMPRESS SUBDIRECTORIES)

for %%d in (. System32 SysWOW64) do if exist "%WINDIR%\%%d" compact /exe:lzx /c /i "%WINDIR%\%%d\*"

REM Windows subdirs

for %%d in (
 appcompat assembly Containers Cursors Globalization Help
 IME ImmersiveControlPanel inf InputMethod Installer
 Lenovo Media Microsoft.NET ServiceProfiles
 servicing ShellComponents ShellExperiences SoftwareDistribution
 Speech Speech_OneCore SystemApps SystemResources
 UUS WUModels
) do if exist "%WINDIR%\%%d" compact /exe:lzx /c /i "%WINDIR%\%%d\*" /s

REM System32/SysWOW64 subdirs

for %%d in (
 Catroot downlevel en en-US F12 IME Keywords Licenses LogFiles Nui Speech
 Speech_OneCore wbem WinMetadata WindowsPowerShell
) do (
 if exist "%WINDIR%\System32\%%d" compact /exe:lzx /c /i "%WINDIR%\System32\%%d\*" /s
 if exist "%WINDIR%\SysWOW64\%%d" compact /exe:lzx /c /i "%WINDIR%\SysWOW64\%%d\*" /s
)

REM ProgramData folders
for %%d in (
 Adobe Lenovo McAfee
 Microsoft\ClickToRun Microsoft\Windows "Microsoft\Windows Defender"
 USOPrivate USOShared
) do if exist "%programdata%\%%d" compact /exe:lzx /c /i "%programdata%\%%d\*" /s

REM Program Files folders
if exist "%ProgramFiles(x86)%" (
	compact /exe:lzx /c /i "%ProgramFiles(x86)%\*" /s
	if exist "%ProgramW6432%" compact /exe:lzx /c /i "%ProgramW6432%\*" /s
) else (
	if exist "%ProgramFiles%" compact /exe:lzx /c /i "%ProgramFiles%\*" /s
)

REM Windows files that should generally always be safe to compress
for %%d in (xml htm js) do if exist "%WINDIR%" compact /exe:lzx /c /i "%WINDIR%\*.%%d" /s
