#!/bin/bash

folderName=$1
dataFolder=$folderName
prefix=`echo $folderName | awk -F'/' '{print $(NF-1)}'`
Spectrum_Report_file=$dataFolder$prefix\_Spectrum_Report.txt
dos2unix -q $Spectrum_Report_file

cat $Spectrum_Report_file | sed -n '/^# Spectrum Results$/,/^$/{//b;p}' | awk 'NR==2||NR==4{print}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'Comment'| awk  -F',' 'NR==2{print $1}' | xargs
