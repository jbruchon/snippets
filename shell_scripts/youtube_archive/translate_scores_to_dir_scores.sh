#!/bin/bash

# Converts a scores.txt file to a dirscores.txt file that shows
# the average scores on a per-directory basis

CUR=NONE; TOT=0; CNT=0
sort -k2 scores.txt | cut -d/ -f1-2 | while read LINE
	do
	[ -z "$LINE" ] && continue
	SZ=$((${LINE// .*/} / 1024))
	D="${LINE/#* .\//}"
	if [ "$CUR" != "$D" ]
		then
		# Output the score
		[[ "$CNT" != "0" && "$CUR" != "NONE" ]] && if [[ "$1" = "bulk" ]]
			then echo "$((TOT / 64 * CNT)) $CUR"
			else echo "$((TOT / CNT)) $CUR"
		fi

		CUR="$D"
		TOT=0
		CNT=0

		else
		TOT=$((TOT + SZ))
		CNT=$((CNT + 1))
	fi
done
