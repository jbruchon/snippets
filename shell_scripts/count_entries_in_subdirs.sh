#!/bin/sh

for X in */
	do echo "$(find "$X" -mindepth 1 -maxdepth 1 | wc -l) $X"
done | sort -g
