#!/bin/bash

# Finds video files that have no audio tracks

find . -type f | grep '\.[mw][pke][4vb]m*$' | while read X
	do
	[[ $V = 1 ]] && echo "$X" >&2
	[[ $X =~ */encoded/nodelete/* ]] && echo "X is equal: $X"
	ffprobe "$X" 2>&1 | grep -q 'Stream.*Audio: ' || echo "$X"
done | sed 's/.[mw][pke][4vb]m*$/.info.json/;s#\(/[^/]*\)#\1/metadata#;s#/encoded/nodelete##' | while read LINE
	do
	A=${LINE/.\//}; A=${A%%/*}
	URL="$(tr '{}' \\n < "$LINE" | grep 'webpage_url.*watch?v=' | sed 's#.*https://www.youtube.com/#https://www.youtube.com/#;s/",.*//;')"
	echo "$A:$URL"
done
