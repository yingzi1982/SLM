#!/bin/bash

for name in  Ludvika Vasteras; do
#for name in  Vasteras; do
for folder in `ls -dp -- ../data/office/$name/*SLM*`; do
  echo Proccessing data in $folder
  #rm -f $folder\LA*
  ./read_reports.sh $folder
  #rm -f $folder\*wav
  #./read_wav_file.sh $folder 0.1 10

  ./gmt.sh $folder
done
done

./gmt_singles.sh ../data/office/
