#!/bin/bash

folderName=office
testName=MyTest1
dateLabel=2023-11-24
sessionNumber=1
positionNumber=3

sessionNumberFmt=`printf "%03d" $sessionNumber`
positionNumberFmt=`printf "%02d" $positionNumber`

wavFolder=../data/$folderName/$testName\_$dateLabel\_SLM_$sessionNumberFmt\/Position_#$positionNumberFmt

./octave.sh ./read_wav_file.m $wavFolder
