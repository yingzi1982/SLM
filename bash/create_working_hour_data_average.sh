#!/bin/bash

measurementFolder=Ludvika

for measurementFolder in Ludvika Vasteras; do

if  [[ $measurementFolder == "Ludvika" ]];
then
dataFolderList="2024-03-21_SLM_001 2024-03-22_SLM_001 2024-03-25_SLM_001 2024-03-26_SLM_001 2024-03-27_SLM_001"
elif [[ $measurementFolder == "Vasteras" ]];
then
dataFolderList="2024-04-08_SLM_001 2024-04-09_SLM_001 2024-04-10_SLM_001 2024-04-11_SLM_001 2024-04-12_SLM_001 "
fi

for nameSegmentation in LAeq LAF10 LAF90; do
dataFile=../data/office/$measurementFolder/$nameSegmentation
>$dataFile
for dataFolder in $dataFolderList; do
cat ../data/office/$measurementFolder/$dataFolder/$nameSegmentation\Segmentation | awk 'NR>=10&&NR<=17{print $2}' >> $dataFile
done
done
done

./octave.sh generate_working_hour_data_average.m
