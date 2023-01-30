#!/bin/sh

# Move youtube-dl metadata files to a "metadata/" directory for each archive directory

WD="$(pwd)"

echo "Moving metadata in dirs:"
for X in */
	do mkdir -p "$X/metadata" "$X/encoded/nodelete"
	echo "$X"
	cd "$X" && mv *.jpg *.json *.description *.webp *.vtt metadata/ 2>/dev/null
	cd "$WD"
done
