#!/bin/bash

/Test_Uppsala/MyTest_2023-12-17_SLM_001$
folderName=Test_Uppsala
testName=MyTest
dateLabel=2023-12-17
sessionNumber=1
positionNumber=1

sessionNumberFmt=`printf "%03d" $sessionNumber`
positionNumberFmt=`printf "%02d" $positionNumber`

wavFolder=../data/$folderName/$testName\_$dateLabel\_SLM_$sessionNumberFmt\/Position_#$positionNumberFmt

./read_LA.sh $wavFolder

./read_wav_file.sh $wavFolder

#./gmt.sh
