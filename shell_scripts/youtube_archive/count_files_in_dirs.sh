#!/bin/sh

for X in */; do echo "$(find "$X" -maxdepth 1 -type f -size +2000 | wc -l) $X"; done | sort -g
