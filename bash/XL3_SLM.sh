#!/bin/bash

name=Office
#
for folder in `ls -dp -- ../data/$name/*`; do
  echo Proccessing data in $folder
  #./read_reports.sh $folder
  #./read_wav_file.sh $folder 0.1 10
  ./gmt.sh $folder
done
