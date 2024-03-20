#!/bin/bash

folderName=$1
dataFolder=$folderName
prefix=`echo $folderName | awk -F'/' '{print $(NF-1)}'`
Report_file=$dataFolder$prefix\_Report.txt
dos2unix -q $Report_file

receiver_label=`cat $Report_file | sed -n '/^# Spectrum Results$/,/^$/{//b;p}' | awk 'NR==2||NR==4{print}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'Comment'| awk  -F',' 'NR==2{print $1}' | tr -d ' '`
if [ -z "$receiver_label" ]
then
receiver_label="NoName"
else
:
fi
echo $receiver_label
