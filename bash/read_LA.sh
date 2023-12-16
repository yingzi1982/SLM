#!/bin/bash

wavFolder=$1

Report_file=`ls -1 $wavFolder\/*_Report.txt | head -n 1`
Spectrum_Report_file=`ls -1 $wavFolder\/*_Report.txt | tail -n 1`

dos2unix -q $Report_file
dos2unix -q $Spectrum_Report_file

LAeq_fullband=`awk 'NR==21{print $14}' $Report_file`
echo 0 fullband $LAeq_fullband >  ../backup/LA

thirdOctaveBand=`awk 'NR==18{for(i=8;i<=NF;++i)print $i}' $Spectrum_Report_file`

LAeq=`awk 'NR==20{for(i=5;i<=NF;++i)if($i<0||$i=="-nan"){print 0}else{print $i}}' $Spectrum_Report_file`

paste <(echo "$thirdOctaveBand") <(echo "$LAeq") --delimiters ' ' | cat -n >> ../backup/LA
