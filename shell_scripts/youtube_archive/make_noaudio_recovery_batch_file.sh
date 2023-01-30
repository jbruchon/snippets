#!/bin/bash

# Make a youtube-dl downloader batch file for files with no audio

BF="get_noaudio_urls.bat"

: > $BF
unset CUR

ND=1; NF=0

while IFS="" read -r LINE
	do
	D="${LINE/:*/}"
	[ -z "$CUR" ] && CUR="$D" && echo "cd \"$D\"" >> $BF
	[ "$D" != "$CUR" ] && CUR="$D" && ND=$(( ND +1 )) && echo "cd \"..\\$D\"" >> $BF
	U="${LINE/*:http/http}"
	echo "call \download_entire_youtube_channel_noarchive.bat \"$U\"" >> $BF
	NF=$(( NF + 1 ))
	echo -en "\rProcessed dirs $ND, files $NF"
done < noaudio_.txt
echo "cd .." >> $BF
echo
