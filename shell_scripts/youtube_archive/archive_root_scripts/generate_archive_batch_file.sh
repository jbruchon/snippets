#!/bin/bash

if [[ "$1" == "-h" ]]; then
    echo "vars: DRIVE, YTC, CHANMAP, BATFILE"
    exit
fi

# Set default variables if they are not currrently set
if [[ -z "${DRIVE}" ]];   then DRIVE="Y:"; fi
if [[ -z "${YTC}" ]];     then YTC="YouTube Channels"; fi
if [[ -z "${CHANMAP}" ]]; then CHANMAP="yt_channel_mappings.txt"; fi
if [[ -z "${BATFILE}" ]]; then BATFILE="perform_yt_archive_update.bat"; fi

# Ensure the channel mapping file exists
if [[ ! -e "${CHANMAP}" ]]; then
    echo "File ${CHANMAP} missing"
    exit 1
fi

printf "@echo off\r\n" >"${BATFILE}"
printf "pushd \"${DRIVE}\\${YTC}\"\r\n" >>"${BATFILE}"
while IFS='=' read -ra LINE; do
    channel_name="${LINE[0]}"
    channel_url=$(echo "${LINE[1]}" | tr -d '\r')

    if [[ "${channel_name:0:1}" == "#" ]]; then
        continue
    fi

    printf 'md "%s"\r\n' "${channel_name}" >>"${BATFILE}"
    printf 'pushd "%s"\r\n' "${channel_name}" >>"${BATFILE}"
    printf 'call "%%~dp0\\download_entire_youtube_channel.bat" "%s"\r\n' "${channel_url}" >>"${BATFILE}"
    printf "popd\r\n" >>"${BATFILE}"
done <"${CHANMAP}"
printf "popd\r\n" >>"${BATFILE}"
