#!/bin/bash

CNT="cnt_temp.txt"
SCORES="dirscores_temp.txt"

# Generate count file
rm -f $CNT $SCORES
for X in */
	do echo "$(find "$X" -maxdepth 1 -type f -size +2000 | wc -l) $X" | tr -d /
done > $CNT

# Generate dirscores file
./translate_scores_to_dir_scores.sh > $SCORES

# Combine dirscore and file count into a unified number
while read -r X
	do
	read -r -a NA <<< "$X"
	S="${NA[0]}"
	N="${NA[@]:1}"
	C="$(grep " ${N}\$" $CNT)"
	C="${C/ */}"
	echo "$((C * S / 128)) $N"
done < $SCORES | sort -g

rm $CNT $SCORES
