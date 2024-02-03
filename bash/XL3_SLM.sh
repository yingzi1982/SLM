#!/bin/bash

testName=Test

for folder in `ls -dp -- ../data/$testName/*`; do
  echo Proccessing data in $folder
  ./read_reports.sh $folder
  ./read_wav_file.sh $folder 0.1 10
  ./gmt.sh $folder
done
