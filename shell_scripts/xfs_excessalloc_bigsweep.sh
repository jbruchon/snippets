#!/bin/bash

# Excessive allocation mass cleanup script
# Copyright (C) 2022 by Jody Bruchon <jody@jodybruchon.com>
# Distributed under The MIT License
#
# This script scans for excess data allocation sizes on files and runs
# truncate on those files to clear all excess allocations found.
# It starts at the current directory and recurses until all possible
# excessively allocated files are located and processed.
#
# WARNING: Colons : are used as field separators. This may misbehave if
# file paths with colons exist, though it's coded not to.


# Minimum difference in bytes to consider "excess" (default to 4K blocks)
[ -z "$MIN" ] && MIN=$((4 * 1024))

ST=0
declare -a FN
BATCHSIZE=1024
CNT=0; TOTAL=0; PROG=0; TDIFF=0

[ -z "$TRUNCATE" ] && TRUNCATE=truncate
[ "$1" = "-n" ] && echo "No-action mode enabled" && TRUNCATE="echo truncate"

update_progress () {
	PROG=$((PROG + 1))
	[ $PROG -ge 64 ] && PROG=0 && echo -n "Processed $TOTAL files"$'\r'
}

# Once enough entries are loaded, split the stat fields, check, and truncate
process_batch () {
	IDX=0
	[ ! -z "$V" ] && echo $'\n'"Running batch of $CNT files"
	while [ $IDX -lt $CNT ]
		do
		S=${FN[$IDX]}
		FILE="${S/*:*:*:/}"
		BLOCKS="${S%%:*}"
		BS="${S#*:}"; BS="${BS%%:*}"
		SIZE="${S#*:*:}"; SIZE="${SIZE%%:*}"
		ALLOC=$((BLOCKS * BS))
		DIFF=$((ALLOC - SIZE))
		[ "$V" = "1" ] && echo "debug: $BLOCKS * $BS = $ALLOC - $SIZE = $DIFF (file '$FILE')"

		# If a minimum size is set, zero anything lower; ignore such files
		[ ! -z "$MIN" ] && [ $DIFF -lt $MIN ] && DIFF=0
		[ $DIFF -ne 0 ] && echo "$DIFF $FILE" && $TRUNCATE -cr "$FILE" "$FILE"
		TDIFF=$((TDIFF + DIFF))
		IDX=$((IDX + 1))
	done
	CNT=0
}

# Main loop
while read -r FILE
	do
	FN[CNT]="$(stat -c '%b:%B:%s:%n' "$FILE" || echo)"
	test -z "$FN" && echo "Error reading file" >&2 && ST=1 && continue
	[ "$V" = "1" ] && echo "debug: file $FILE, FN ${FN[$CNT]})"
	TOTAL=$((TOTAL + 1))
	[ "$V" != "1" ] && update_progress
	CNT=$((CNT + 1))
	[ $CNT -ge $BATCHSIZE ] && process_batch
done < <(find . -type f)

# Process any less-than-BATCHSIZE set of files
echo
[ $CNT -gt 0 ] && process_batch

echo "Cleared $TDIFF excess bytes ($((TDIFF / 1048576)) MB)"

exit $ST
