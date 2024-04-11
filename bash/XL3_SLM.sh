#!/bin/bash

name=LudvikaOfficeNoise
#
for folder in `ls -dp -- ../data/$name/*`; do
#for folder in `ls -dp -- ../data/$name/2024-03-31_SLM_001`; do
  echo Proccessing data in $folder
  #./read_reports.sh $folder
  #./read_wav_file.sh $folder 0.1 10
  ./gmt.sh $folder
done
