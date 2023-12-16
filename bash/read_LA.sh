#!/bin/bash

wavFolder=$1
echo $wavFolder

LAeqFile=`ls $wavFolder\/*Spectrum_Report.txt`
dos2unix -q $LAeqFile

thirdOctaveBand=`awk 'NR==18{for(i=8;i<=NF;++i)print $i}' $LAeqFile`

LAeq=`awk 'NR==20{for(i=5;i<=NF;++i)if($i<0||$i=="-nan"){print 0}else{print $i}}' $LAeqFile`

paste <(echo "$thirdOctaveBand") <(echo "$LAeq") --delimiters ' ' | cat -n > ../backup/LA
