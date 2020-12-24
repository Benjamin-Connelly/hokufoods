#!/usr/bin/env bash

set -e
set noclobber
shopt -s extglob

today=$(date -v+1m  +"%m-%Y")

# Set terminal working directory
cd -- "$(dirname "$0")"

# Create a directory named month-year - 01-2017, etc...
(IFS=';'; set -f; mkdir -- $today) 

# Crop the image to remove register marks and save them in the month-year directory. 
for specials in `ls *.pdf`; do
   pdfcrop --margins '-10 -23 -10 -30' $specials  $today/"${file%%.*}";
done

# Change directory to correct month-year.
cd $today

# Crop images to be 2up (1/2 page) and set their size to as close to 800X400 pixels. 
for file in `ls *.pdf`; do
  convert -density 400 $file -crop 100%x50% -resize 800x400 "${file%%.*}".jpg;
done

# Rename JPG files with month-year-number.jpg
n=0;
for file in *.jpg ; do mv  "${file}" $today"_${n}".jpg; ((n++));  done

# Clean up temp PDF files
rm -rf *.pdf
