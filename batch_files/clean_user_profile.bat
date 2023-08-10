@rem Cleanup script by Jody Bruchon <jody@jodybruchon.com>

cd "%USERPROFILE%\APPDATA"

# Close browsers/programs
for %%d in (msedge firefox chrome brave rdrcef slack dialpad CiscoCollabHost) do taskkill /f /im "%%d.exe"

rem Firefox caches/storage
rd /s /q "%LOCALAPPDATA%\Mozilla"
rd /s /q "%APPDATA%\Mozilla\Firefox\Crash Reports"
for /f "usebackq delims=" %%d in (`dir /b Roaming\Mozilla\Firefox\Profiles\`) do for /f usebackq %%e in (`dir /b "Roaming\Mozilla\Firefox\Profiles\%%d\storage\default"`) do rd /s /q "Roaming\Mozilla\Firefox\Profiles\%%d\storage\default\%%e"
for /f "usebackq delims=" %%d in (`dir /b Roaming\Mozilla\Firefox\Profiles\`) do for %%e in (crashes datareporting minidumps saved-telemetry-pings) do rd /s /q "Roaming\Mozilla\Firefox\Profiles\%%d\%%e"

rem Chrome/Chromium caches
for /f "usebackq delims=" %%d in (`dir /s /b "Cache"`) do rd /s /q "%%d"
for /f "usebackq delims=" %%d in (`dir /s /b "Code Cache"`) do rd /s /q "%%d"
for /f "usebackq delims=" %%d in (`dir /s /b "Crashpad"`) do rd /s /q "%%d"
for /f "usebackq delims=" %%d in (`dir /s /b "GPUCache"`) do rd /s /q "%%d"
for /f "usebackq delims=" %%d in (`dir /s /b "Service Worker"`) do rd /s /q "%%d"

rem System/user temp folders
for /f "usebackq delims=" %%d in (`dir /b /a:d "%TEMP%\"`) do rd /s /q "%TEMP%\%%d"
for /f "usebackq delims=" %%d in (`dir /b /a:d "%WINDIR%\Temp\"`) do rd /s /q "%WINDIR%\Temp\%%d"
for /f "usebackq delims=" %%d in (`dir /b /a:-d "%TEMP%\"`) do del /q "%TEMP%\%%d"
for /f "usebackq delims=" %%d in (`dir /b /a:-d "%WINDIR%\Temp\"`) do del /q "%WINDIR%\Temp\%%d"

rem Cisco WebEx
for %%d in (accessories bwc media) do rd /s /q "%LOCALAPPDATA%\CiscoSpark\%%d"
for /f "usebackq delims=" %%d in (`dir /b /a:-d "%LOCALAPPDATA%\CiscoSpark\*.zip"`) do del /q "%LOCALAPPDATA%\CiscoSpark\%%d"

rem Windows Search cache
rd /s /q "%LOCALAPPDATA%\Packages\Microsoft.Windows.Search_cw5n1h2txyewy\LocalState\DeviceSearchCache"

rem Dialpad
rd /s /q "%LOCALAPPDATA%\Dialpad\Packages"

rem Slack
rd /s /q "%LOCALAPPDATA%\Slack\Packages"
for %%d in (logs DawnCache) do rd /s /q "%APPDATA%\Slack\%%d"

rem Adobe Acrobat Reader Manager (updater)
rd /s /q "%PROGRAMDATA%\Adobe\ARM"

rem Zoom
rd /s /q "%APPDATA%\Zoom\zoom_install_src"
rd /s /q "%APPDATA%\Zoom\ZoomDownload"

rem MS Edge Update
for %%d in (Download Install Temp) do rd /s /q "%ProgramFiles(x86)%\Microsoft\EdgeUpdate\%%d"

rem Compact everything
compact /exe:lzx /c /s /i *