#!/bin/bash

# Minimum difference in bytes to consider "excess" (default to 4K blocks)
[ -z "$MIN" ] && MIN=4096

test -z "$1" && echo "Specify a file to check for excess allocation" >&2 && exit 1

FILE="$@"
if [ ! -e "$FILE" ]
	then echo "Does not exist: '$FILE'" >&2
	exit 1
fi

S="$(stat -c '%b:%B;%s' "$FILE" || echo)"
test -z "$S" && echo "Error reading file" >&2 && exit 1

BLOCKS="${S/:*/}"
BS="${S/*:/}"; BS="${BS/;*/}"
SIZE=${S/*;/}
ALLOC=$((BLOCKS * BS))
DIFF=$((ALLOC - SIZE))
[ "$V" = "1" ] && echo "debug: $BLOCKS * $BS = $ALLOC - $SIZE = $DIFF"

# If a minimum size is set, zero anything lower
[ ! -z "$MIN" ] && [ $DIFF -lt $MIN ] && DIFF=0

echo "$DIFF $FILE"
