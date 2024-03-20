#!/bin/bash

name=$1
folder=$2
startTime=$3
duration_in_minute=$4

endTime=`date -d "$startTime $duration_in_minute minutes" +"%Y-%m-%dT%H:%M:%S"`

t=`date -f <(cat $folder$name | awk -v startTime="$startTime" -v endTime="$endTime" 'NR>1 && ($1>=startTime) && ($1<=endTime){print $1}') "+%s" | awk '{if(NR==1){zeroTime=$1}{print ($1-zeroTime)/60}}'`
v=`cat $folder$name | awk -v startTime="$startTime" -v endTime="$endTime" 'NR>1 && ($1>=startTime) && ($1<=endTime){print $2}'`

cat $folder$name | head -n 1
paste <(echo "$t") <(echo "$v") --delimiters ' '  
