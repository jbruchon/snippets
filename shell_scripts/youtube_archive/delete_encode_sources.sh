#!/bin/sh

echo "Clearing sources for encoded videos"

test ! -d "encoded" && echo "No encoded directory found" && exit 1
for X in *.*
	do
	Y="$(echo "$X" | grep '\.[mw][kpe][v4b]m*$' | grep -v '\.sh$' | sed 's/.[mw][kpe][v4b]m*$/.mp4/')"
	test -z "$Y" && continue
	test -e "encoded/$Y" && echo "$X" && rm "$X"
done
