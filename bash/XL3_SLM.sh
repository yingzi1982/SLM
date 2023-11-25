#!/bin/bash

folderName=calibrator
testName=MyTest1
dateLabel=2023-11-23
sessionNumber=1
positionNumber=1

sessionNumberFmt=`printf "%03d" $sessionNumber`
positionNumberFmt=`printf "%02d" $positionNumber`

wavFolder=../data/$folderName/$testName\_$dateLabel\_SLM_$sessionNumberFmt\/Position_#$positionNumberFmt

./octave.sh ./read_wav_file.m $wavFolder
