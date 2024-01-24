#!/bin/bash

testName=Test

for folderName in `ls -dp -- ../data/$testName/*`; do
  echo Proccessing data in $folderName
  ./read_reports.sh $folderName
  ./read_wav_file.sh $wavFolder
  ./gmt.sh $folderName
done
