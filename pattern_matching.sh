#!/bin/bash

# Searches for each line of file1 in file2 and outputs
# results to a file

echo "Enter file1 to get search terms from: "
read file1
echo "Enter file2 to find search terms in: "
read file2
echo "Enter name of the output file: "
read outfile

cat $file1 | while read line
do
    grep $line $file2 >> $outfile
done


