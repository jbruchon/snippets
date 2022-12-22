@echo off
nircmdc.exe win min foreground
echo Compressing programs with LZX
echo windir = %windir%
echo ProgramFiles(x86) = %ProgramFiles(x86)%
echo ProgramFiles = %ProgramFiles%
echo ProgramW6432 = %ProgramW6432%
if exist "%windir%\System32" compact /exe:lzx /c /i "%windir%\System32\*"
if exist "%windir%\SysWOW64" compact /exe:lzx /c /i "%windir%\SysWOW64\*"
if exist "%windir%" compact /exe:lzx /c /i "%windir%\*"
if exist "%windir%\assembly" compact /exe:lzx /c /i "%windir%\assembly\*" /s
if exist "%windir%\Cursors" compact /exe:lzx /c /i "%windir%\Cursors\*" /s
if exist "%windir%\Globalization" compact /exe:lzx /c /i "%windir%\Globalization\*" /s
if exist "%windir%\IME" compact /exe:lzx /c /i "%windir%\IME\*" /s
if exist "%windir%\ImmersiveControlPanel" compact /exe:lzx /c /i "%windir%\ImmersiveControlPanel\*" /s
if exist "%windir%\InputMethod" compact /exe:lzx /c /i "%windir%\InputMethod\*" /s
if exist "%windir%\Installer" compact /exe:lzx /c /i "%windir%\Installer\*" /s
if exist "%windir%\Media" compact /exe:lzx /c /i "%windir%\Media\*" /s
if exist "%windir%\Microsoft.NET" compact /exe:lzx /c /i "%windir%\Microsoft.NET\*" /s
if exist "%windir%\ServiceProfiles" compact /exe:lzx /c /i "%windir%\ServiceProfiles\*" /s
if exist "%windir%\servicing" compact /exe:lzx /c /i "%windir%\servicing\*" /s
if exist "%windir%\ShellComponents" compact /exe:lzx /c /i "%windir%\ShellComponents\*" /s
if exist "%windir%\ShellExperiences" compact /exe:lzx /c /i "%windir%\ShellExperiences\*" /s
if exist "%windir%\SoftwareDistribution" compact /exe:lzx /c /i "%windir%\SoftwareDistribution\*" /s
if exist "%windir%\Speech" compact /exe:lzx /c /i "%windir%\Speech\*" /s
if exist "%windir%\Speech_OneCore" compact /exe:lzx /c /i "%windir%\Speech_OneCore\*" /s
if exist "%windir%\SystemApps" compact /exe:lzx /c /i "%windir%\SystemApps\*" /s
if exist "%windir%\SystemResources" compact /exe:lzx /c /i "%windir%\SystemResources\*" /s
rem if exist "%windir%\System32\DriverStore" compact /exe:lzx /c /i "%windir%\System32\DriverStore\*" /s

if exist "%programdata%\Microsoft\Windows Defender" compact /exe:lzx /c /i "%programdata%\Microsoft\Windows Defender\*" /s
if exist "%programdata%\Adobe" compact /exe:lzx /c /i "%programdata%\Adobe\*" /s

if exist "%ProgramFiles(x86)%" (
	compact /exe:lzx /c /i "%ProgramFiles(x86)%\*" /s
	if exist "%ProgramW6432%" compact /exe:lzx /c /i "%ProgramW6432%\*" /s
) else (
	if exist "%ProgramFiles%" compact /exe:lzx /c /i "%ProgramFiles%\*" /s	
)

if exist "%windir%\inf" compact /exe:lzx /c /i "%windir%\inf\*"
if exist "%windir%" compact /exe:lzx /c /i "%windir%\*.xml" /s
if exist "%windir%" compact /exe:lzx /c /i "%windir%\*.htm" /s
if exist "%windir%" compact /exe:lzx /c /i "%windir%\*.js" /s