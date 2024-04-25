#!/bin/bash

for name in  Ludvika Vasteras; do
for folder in `ls -dp -- ../data/office/$name/*SLM*`; do
  echo Proccessing data in $folder
  #./read_reports.sh $folder
  #./read_wav_file.sh $folder 0.1 10
  ./gmt.sh $folder
done
done

#./gmt_singles.sh ../data/office/
