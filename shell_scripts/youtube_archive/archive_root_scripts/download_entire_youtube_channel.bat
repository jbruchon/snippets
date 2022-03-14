@echo off

:: Constants
set "ROOT_DIR=%~dp0"
set "COOKIE_FILE=%ROOT_DIR%\cookies.txt"
set "FFMPEG_LOCATION=%ROOT_DIR%\ffmpeg.exe"
set "DL_ARCHIVE=%ROOT_DIR%\yt_dl_archive.txt"
set "PLE=50"
set "YOUTUBE_DL=%ROOT_DIR%\yt-dlp.exe"

:: Toggle nothrottle and noarchive based on provided arguments
set /a "nothrottle=0", "noarchive=0"
set "throttle_args=--throttled_rate 50k"
set "archive_args=--download_archive "%DL_ARCHIVE%""
for %%A in (%*) do (
    if "%%A"=="--nothrottle" set "nothrottle=1"
    if "%%A"=="--noarchive" set "noarchive=1"
)
if "%nothrottle%"=="0" set "throttle_args="
if "%noarchive%"=="0" set "archive_args="
set "yt_dlp_url=%*"
set "yt_dlp_url=%yt_dlp_url: --nothrottle=%"
set "yt_dlp_url=%yt_dlp_url: --noarchive=%"

:: Build yt-dlp options string
set yt_dlp_options=--ffmpeg-location "%FFMPEG_LOCATION%"
set yt_dlp_options=%yt_dlp_options% --match-filter "!is_live & !live"
set yt_dlp_options=%yt_dlp_options% --cookies "%COOKIEFILE%"
set yt_dlp_options=%yt_dlp_options% --add-metadata --write-description
set yt_dlp_options=%yt_dlp_options% --write-info-json --write-thumbnail 
set yt_dlp_options=%yt_dlp_options% %throttle_args% %archive_args%
set yt_dlp_options=%yt_dlp_options% --write-subs --write-auto-subs
set yt_dlp_options=%yt_dlp_options% --sub-lang en,en_US --convert-subs srt
set yt_dlp_options=%yt_dlp_options% -ciw -o "%%(title)s.%%(ext)s" -v

:: Main command
"%YOUTUBE_DL%" %yt_dlp_options% "%yt_dlp_url%"