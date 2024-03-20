#!/bin/bash

folderName=$1
dataFolder=$folderName
prefix=`echo $folderName | awk -F'/' '{print $(NF-1)}'`
Spectrum_Report_file=$dataFolder$prefix\_Spectrum_Report.txt
dos2unix -q $Spectrum_Report_file

Date=`cat $Spectrum_Report_file | sed -n '/^# Spectrum Results$/,/^$/{//b;p}' | awk 'NR==2||NR==4{print}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'Date'| awk  -F',' 'NR==2{print $1}' | xargs`
Time=`cat $Spectrum_Report_file | sed -n '/^# Spectrum Results$/,/^$/{//b;p}' | awk 'NR==2||NR==4{print}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'Time'| awk  -F',' 'NR==2{print $1}' | xargs`
Duration=`cat $Spectrum_Report_file | sed -n '/^# Spectrum Results$/,/^$/{//b;p}' | awk 'NR==2||NR==4{print}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'Duration'| awk  -F',' 'NR==2{print $1}' | xargs`
#time_label="Date: $Date Time: $Time Duration: $Duration"
time_label="$Date, $Time"
echo $time_label
