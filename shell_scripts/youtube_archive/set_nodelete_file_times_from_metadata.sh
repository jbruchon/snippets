#!/bin/bash

while read FILE
	do INFO="${FILE/%mp4/info.json}"
	INFO="${INFO/encoded\/nodelete/metadata}"
	test -e "$INFO" && DT="$(tr , '\n' < "$INFO" | grep '"upload_date":' | sed 's/.*": "\([0-9][0-9][0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\).*/\1-\2-\3 12:00:00/;s/".*//')"
	[ ! -z "$DT" ] && touch -d "$DT" "$FILE" && echo touch -d "$DT" "$FILE"
done < <(find . -mindepth 4 -type f -name '*.mp4' | grep nodelete)
