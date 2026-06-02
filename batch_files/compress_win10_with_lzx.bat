@echo off

echo Compress Windows 10+ Script by Jody Bruchon - jody@jodybruchon.com
echo Last updated 2026-06-02

set OPTS=/c /i
if "%1" EQU "force" set OPTS=/c /i /f
if "%1" EQU "decompress" set OPTS=/u /i

REM Unattended option minimizes the window and doesn't pause
if "%1" NEQ "unattended" goto :nonircmdc
where /q nircmdc.exe
if ERRORLEVEL 1 GOTO nonircmdc
nircmdc.exe win min foreground
:nonircmdc

echo This will LZX compress everything in Windows 10. Hit CTRL+C to abort.
echo Behavior modification keywords: force, decompress, unattended
echo WINDIR = %WINDIR%
echo ProgramFiles(x86) = %ProgramFiles(x86)%
echo ProgramFiles = %ProgramFiles%
echo ProgramW6432 = %ProgramW6432%
echo ProgramData = %ProgramData%
echo options: %OPTS%
if "%1" NEQ "unattended" pause

REM Windows/System32/SysWOW64 (MUST NOT COMPRESS SUBDIRECTORIES)

for %%d in (. System32 SysWOW64) do if exist "%WINDIR%\%%d" compact /exe:lzx %OPTS% "%WINDIR%\%%d\\*"

REM Windows subdirs

for %%d in (
 appcompat apppatch AppReadiness assembly bcastdvr BitLockerDiscoveryVolumeContents Branding BrowserCore CbsTemp Containers Cursors debug diagnostics
 DiagTrack DigitalLocker "Downloaded Program Files" Firmware GameBarPresenceWriter Globalization Help IdentityCRL IME ImmersiveControlPanel InboxApps INF
 InputMethod Installer L2Schemas LanguageOverlayCache Lenovo LiveKernelReports Logs Media Microsoft.NET Migration ModemLogs OCR "Offline Web Pages"
 Panther Performance PolicyDefinitions PLA PolicyDefinitions Prefetch PrintDialog Provisioning Registration RemotePackages rescache Resources SchCache
 schemas security ServiceProfiles ServiceState servicing Setup ShellComponents ShellExperiences SKB SoftwareDistribution Speech Speech_OneCore system
 SystemApps SystemResources SystemTemp TAPI Tasks tracing twain_32 vss UUS WaaS web WUModels
 af-ZA am-et ar-SA as-IN az-Latn-AZ be-BY bg-BG bn-IN cs-CZ cy-GB da-DK de-DE el-GR en-GB en-US es-ES es-MX et-EE ff-Adlm-SN fi-FI fr-CA fr-FR he-IL
 hr-HR hu-HU it-IT ja-jp ko-KR lt-LT lv-LV my-mm nb-NO nl-NL osa-Osge-001 pl-PL pt-BR pt-PT ro-RO ru-RU si-lk sk-SK sl-SI sr-Latn-RS sv-SE ta-in ta-lk
 th-TH ti-et tr-TR uk-UA zh-CN zh-TW
) do if exist "%WINDIR%\%%d" compact /exe:lzx %OPTS% "%WINDIR%\%%d\\*" /s

REM System32/SysWOW64 subdirs

for %%d in (
 AdvancedInstallers AMD AppLocker appraiser AppV Catroot Catroot2 CodeIntegrity Com compatrel configuration DDFs DiagSvcs dism dolbyaposvc downlevel
 dsc en F12 GroupPolicy GroupPolicyUsers HealthAttestationClient ias icsxml IME inetsrv InputMethod ipmi InstallShield Keywords Licenses LogFiles lxss
 MailContactsCalendarSync migration migwiz Networklist Nui oobe OpenSSH PerceptionSimulation PointOfService Printing_Admin_Scripts SecureBootUpdates
 setup Sgrm SMI Speech Speech_OneCore spp sppui sru Sysprep SystemResetPlatform wbem WDI WinBioDatabase WinBioPlugins WinMetadata WindowsPowerShell Winrm
 af-ZA am-et ar-SA as-IN az-Latn-AZ be-BY bg-BG bn-IN cs-CZ cy-GB da-DK de-DE el-GR en-GB en-US es-ES es-MX et-EE ff-Adlm-SN fi-FI fr-CA fr-FR he-IL
 hr-HR hu-HU it-IT ja-jp ko-KR lt-LT lv-LV my-mm nb-NO nl-NL osa-Osge-001 pl-PL pt-BR pt-PT ro-RO ru-RU si-lk sk-SK sl-SI sr-Latn-RS sv-SE ta-in ta-lk
 th-TH ti-et tr-TR uk-UA zh-CN zh-TW
) do (
 if exist "%WINDIR%\System32\%%d" compact /exe:lzx %OPTS% "%WINDIR%\System32\%%d\\*" /s
 if exist "%WINDIR%\SysWOW64\%%d" compact /exe:lzx %OPTS% "%WINDIR%\SysWOW64\%%d\\*" /s
)

REM ProgramData folders
for %%d in (
 Adobe Lenovo McAfee
 Microsoft\ClickToRun Microsoft\Windows "Microsoft\Windows Defender"
 USOPrivate USOShared
) do if exist "%programdata%\%%d" compact /exe:lzx %OPTS% "%programdata%\%%d\\*" /s

REM Program Files folders
if exist "%ProgramFiles(x86)%" (
	compact /exe:lzx %OPTS% "%ProgramFiles(x86)%\\*" /s
	if exist "%ProgramW6432%" compact /exe:lzx %OPTS% "%ProgramW6432%\\*" /s
) else (
	if exist "%ProgramFiles%" compact /exe:lzx %OPTS% "%ProgramFiles%\\*" /s
)

REM Windows files that should generally always be safe to compress
for %%d in (xml htm js) do if exist "%WINDIR%" compact /exe:lzx %OPTS% "%WINDIR%\\*.%%d" /s
