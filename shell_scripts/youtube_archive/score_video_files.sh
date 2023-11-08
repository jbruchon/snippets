#!/bin/bash

# Copyright (C) 2021-2023 by Jody Bruchon <jody@jodybruchon.com>
# Released under The MIT License

# Use ffprobe duration vs file size to "score" video file "weights"
# Records the scores in a score file, skipping already-present entries
#
# Primarily intended for downscaled archival transcoding
# A higher score indicates a greater size reduction
# This method is not at all perfect, but gives a general idea of what to
# transcode first to maximize free space as fast as possible
#
# This should be run in the root of a collection of folders with videos
# Accepts maximum scan depth as a paramter; default is 2 (one level down)
# Change score file "database" path by setting SF prior to execution

! ffprobe -version 2>/dev/null >/dev/null && echo "ffprobe does not work, aborting" && exit 1

test ! -z "$1" && MAXDEPTH="$1"
test -z "$MAXDEPTH" && MAXDEPTH=2

test -z "$SF" && SF=scores.txt

SD="2000-01-01"
RD=$(date +%s -d "$SD 00:00:00")
BASERES=76800  # 320x240 - not 960x540 so we have a "fractional" component

# Stats
declare -i DROPPED=0
declare -i EXIST=0
declare -i ADDED=0
declare -i TOTAL=0

declare -A SCK

# Load scores file; skip any missing files
unset SFN
declare -i SCORES=0
test -e "$SF" && while read -r X
	do
	[ -z "$X" ] && continue
	SFN[SCORES]="${X#* }"
	if [ ! -e "${SFN[$SCORES]}" ]
		then
#		echo -e "\nDrop: '$X' = '${SFN[$SCORES]}'\n"
		unset SFN[SCORES]
		(( DROPPED++ ))
		continue
	fi
	SSZ[SCORES]="${X%% *}"
	# Use associative array as a fast lookup table
	SCK[${SFN[$SCORES]}]=1
	(( SCORES++ ))
	[ $(( SCORES % 256 )) -eq 0 ] && echo -en "Loading scores file: $SCORES\r"
done < <(sort -k2 "$SF")

while read -r FILE
	do
	test -z "$FILE" && continue
	(( TOTAL++ ))
#	echo "LOOP: '$FILE' TOTAL=$TOTAL SCORES=$SCORES ADDED=$ADDED"
	# Check to see if the file is already present, and skip if so
	declare -i I=0
	if [ ! -z "${SCK[$FILE]}" ]
		then (( EXIST++ ))
		continue
		else
		while [[ $I -lt $SCORES ]]
			do
			if [ "$FILE" = "${SFN[$I]}" ]
				then
				(( EXIST++ ))
				continue 2
			fi
			(( I++ ))
		done
	fi

	# Calculate a multiplier based on the video resolution
	FULLRES=$(ffprobe "$FILE" 2>&1 | grep Stream.*Video: | tr ' ,' '\n' | grep '[0-9][0-9][0-9]*x[0-9][0-9][0-9]*')
	HRES=${FULLRES%%x*}
	VRES=${FULLRES##*x}
#	echo -e "FILE=$FILE\nHRES=$HRES\nVRES=$VRES\nBASERES=$BASERES\nFULLRES=$FULLRES"
	RES=$((HRES * VRES / BASERES))
	# Resolution multiplier must be at least 1
	test "$RES" -eq "0" && RES=1

	# Get file size in bytes using stat
	SZ=$(stat -c %s "$FILE")
	# Get duration of video in seconds
	DUR=$(ffprobe "$FILE" 2>&1 | grep -i 'duration\s*:\s' | tr -d \  | head -n 1 | cut -d: -f2-4 | cut -d. -f1)
	LD=$(date +%s -d "$SD $DUR")
	T=$(expr $(date +%s -d $DUR) - $(date +%s -d 00:00:00))
	test -z "$T" && T=999999999
	SCORE=$((SZ / T * RES))

	# Add score to score list
#	echo -e "\n$SCORE  $RES  $T  $SZ  $FILE"
	(( SCORES++ )); (( ADDED++ ))
	SSZ[$SCORES]="$SCORE"
	SFN[$SCORES]="$FILE"
	SCK[${SFN[$SCORES]}]=1
	[ $((TOTAL % 32)) -eq 0 ] && echo -en "\rDropped $DROPPED, checked $TOTAL, added $ADDED, already had $EXIST"
#	echo "LOOP END: '$FILE' TOTAL=$TOTAL SCORES=$SCORES ADDED=$ADDED"
done < <(find -mindepth 2 -maxdepth $MAXDEPTH -type f -size +1000 | grep -e '\.webm$' -e '\.mkv$' -e '\.mp4$' | sort -g)
echo -e "\rScanned $TOTAL, added $ADDED, already had $EXIST, dropped $DROPPED"

# Build new score file
[ $((ADDED + DROPPED)) = 0 ] && echo "Scores list is unchanged; not writing a new scores file" && exit
declare -i I=0
while [ $I -lt $SCORES ]
	do
	[ $(( I % 256 )) = 0 ] && echo -en "\rWriting: $I" >&2
	(( I++ ))
	OUT="${SSZ[$I]} ${SFN[$I]}"
	[[ -z "$OUT" || "$OUT" = " " ]] && continue
	echo "$OUT"
done > "$SF"
echo -e "\rWriting: $I...done!" >&2
