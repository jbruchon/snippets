#!/bin/bash

shopt -s nullglob

# Attempts to defragment a directory by moving its contents to a new temporary
# directory, deleting the old one, and renaming the new one to the original
# name, restoring the original modify time and permissions

TEMPNAME=__REFRESH_TEMP__

if [ -d "$1" ]
	then cd "$1"
	echo "Refreshing all directories in '$1'"
	else
	echo "Refreshing all directories in this directory"
fi

rmdir -p $TEMPNAME 2>/dev/null
test -e $TEMPNAME && \
	echo "$TEMPNAME dir exists after rmdir attempt; aborting" && exit 1

while read -r X
	do echo "$X"
	test -h "$X" && echo "Skipping symlink: $X" && continue
	mountpoint -q "$X" && echo "Skipping mountpoint: $X" && continue
	rmdir -p $TEMPNAME 2>/dev/null
	DT="$(stat -c '%y' "$X" | cut -d. -f1)"
	PERM="$(stat -c '%a' "$X")"
	OWN="$(stat -c '%u:%g' "$X")"
	mkdir "$X"$TEMPNAME && \
		find "$X/" -mindepth 1 -maxdepth 1 -exec mv -i '{}' "$X$TEMPNAME/" + &&
		rmdir "$X" && \
		mv "$X"$TEMPNAME "$X"
	# Restore modify date/time, permissions, and UID/GID
	touch -d "$DT" "$X"
	chown $OWN "$X"
	chmod $PERM "$X"
done < <(find . -xdev -mindepth 1 -maxdepth 1 -type d | sort -fg)
#		mv "$X"/* "$X"/.??* "$X"$TEMPNAME/ && \
