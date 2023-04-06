#!/bin/sh

# In a directory of Git project directories, enter each and 'git pull'
# Add 'prune' to prune after pulling, or 'gc' to prune aggressively

WD="$(pwd)"

for X in */
	do cd "$X"
	echo "$X"
	git pull
	test "$1" = "prune" && git gc --prune
	test "$1" = "gc" && git gc --prune --aggressive
	cd "$WD"
done
