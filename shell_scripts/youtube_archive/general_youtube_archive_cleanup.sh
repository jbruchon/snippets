#!/bin/bash

# Move youtube-dl metadata files to "metadata/" directory for each archive dir
# Clean out sources for encoded videos and move them to "encoded/nodelete/"
# Remove IP address info from .info.json files if "sanitize" is passed

shopt -s nullglob

WD="$(pwd)"

echo "Cleaning up and organizing YouTube archive folders"
declare -i NUM=0 SRCSIZE=0 ENCSIZE=0 SRCTOTAL=0 ENCTOTAL=0 FCNT=0 AVG=0 REMOVED=0
for X in */
	do
	NUM=$((NUM + 1))
	echo -en "\rProcessing: $NUM"
	[ "$1" != "nodirs" ] && mkdir -p "$X/metadata" "$X/encoded/nodelete"
	cd "$X" && [ -d "metadata" ] && mv -- *.jpg *.json *.description *.webp *.srt *.vtt *.meta metadata/ 2>/dev/null
	# Sanitize IP addresses from .info.json files (TAKES A LONG TIME)
	if [ "$1" = "sanitize" ]
		then while read NAME
			do sed -i 's/"formats*":[^]]*], "//g;s/&ip=[0-9a-f][0-9a-f.:]*//g' "$NAME"
		done < <(find metadata -type f -name '*.info.json' -print)
	fi
	# Delete encoded sources, move videos to nodelete
	if [ -d encoded ] && cd encoded/
		then CNT=0
		for FILE in *.mp4
			do
			CNT=$((CNT + 1))
			REMOVED=0
			for EXT in mp4 webm mkv
				do DEL="${FILE/%mp4/$EXT}"
				[ -e "../$DEL" ] && \
					ENCSIZE="$(du -s "$FILE" |  cut -f1)" && \
					SRCSIZE="$(du -s "../$DEL" | cut -f1)" && \
					SRCTOTAL=$((SRCTOTAL + SRCSIZE)) && FCNT=$((FCNT + 1)) && \
					touch -r "../$DEL" "$FILE" && rm -f "../$DEL" && REMOVED=1
			done
			[ $REMOVED -eq 1 ] && ENCTOTAL=$((ENCTOTAL + ENCSIZE))
		done
		[ "$CNT" -gt 0 ] && [ -d nodelete/ ] && mv -f -- *.mp4 nodelete/
	fi
	cd "$WD"
done
TOTALFREE=$((SRCTOTAL - ENCTOTAL))
TOTALFREE=$((TOTALFREE / 1024))
[ $FCNT -gt 0 ] && AVG=$((TOTALFREE / FCNT))
echo " ...done ($FCNT replaced, $TOTALFREE MB freed, avg $AVG MB/file)"
