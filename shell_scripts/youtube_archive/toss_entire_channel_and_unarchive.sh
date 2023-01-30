#!/bin/bash

declare -A TOSS
ARCHIVE=../ytdl_archive.txt
TEMP_ARCHIVE=../_temp_archive.txt
BACKUP=../ytdl_backup_archive.txt

[ ! -d "$1" ] && echo "Must specify a channel directory" && exit 1
[[ "$1" = "." || "$1" = "./" || "$1" = "/" || "$1" = ".." ]] && echo "Evil directory, nope" && exit 1
[ ! -e "$ARCHIVE" ] && echo "Missing archive file $ARCHIVE" && exit 1
[ -e "$BACKUP" ] && echo "Backup file exists, remove it first: $BACKUP" && exit 1

echo $'\n'"WARNING: THIS WILL PERMANENTLY DELETE ALL OF THE DOWNLOADED DATA"
echo "FOR CHANNEL:  '$1'"
echo -n $'\n'"TYPE yes IF YOU'RE SURE, or anything else to abort: "

read -r X
[ "$X" != "yes" ] && echo "Aborting." && exit 1

./general_youtube_archive_cleanup.sh

# Load IDs to remove from archive
CNT=1
while read -r X
	do TOSS[$X]=1
	echo -n $'\r'"Deleting $CNT IDs"
	CNT=$((CNT + 1))
done < <(cat "$1"/metadata/*.info.json | tr ',' '\n' | tr '{' '\n' | grep '"id": "..........."' | sed 's/.*"\(.*\)".*/youtube \1/')
echo

# Copy archive, excluding items to toss
CNT=0; GONE=0; INTERVAL=1
while read -r X
	do INTERVAL=$((INTERVAL - 1))
	[ $INTERVAL -le 0 ] && echo -n $'\r'"Processed $CNT, tossed $GONE" && INTERVAL=128
	[ -z "${TOSS[$X]}" ] && CNT=$((CNT + 1)) && echo "$X" >&3 && continue
	GONE=$((GONE + 1))
done < "$ARCHIVE" 3> "$TEMP_ARCHIVE"
echo $'\r'"Processed $CNT, tossed $GONE"

mv -f "$ARCHIVE" "$BACKUP" && mv -f "$TEMP_ARCHIVE" "$ARCHIVE" && rm -r "./$1/"
