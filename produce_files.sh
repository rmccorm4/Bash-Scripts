#!/bin/bash

# PSEUDOCODE
# Start with i = 1
# output_directory = 10_classes_attempts/$i
# Read every 10th line starting from i, ending at i+100 from
# 1) 200_words.txt -> 10_classes_attempts/$i/words10.txt
# 2) wnids.txt -> output/words10.txt

for i in $(seq 1 100)
do
	outdir="../10_class_combinations/$i"
	mkdir -p $outdir
	# Get every 10th line starting at i'th line - only taking first 10 lines of output
	sed -n "$i~10p" < "../wnids.txt" | head > "$outdir/wnids10.txt"
	sed -n "$i~10p" < "../200_words.txt" | head > "$outdir/words10.txt"
done
