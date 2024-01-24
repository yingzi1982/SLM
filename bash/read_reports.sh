#!/bin/bash

folderName=$1
prefix=`echo $folderName | awk -F'/' '{print $(NF-1)}'`

dataFolder=$folderName
#
Report_file=$dataFolder$prefix\_Report.txt
dos2unix -q $Report_file

LAFmax=`cat $Report_file | sed -n '/^# Broadband Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'LAFmax' | awk 'NR==3{print $1}'`
LAFmin=`cat $Report_file | sed -n '/^# Broadband Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'LAFmin' | awk 'NR==3{print $1}'`
LAF90=`cat $Report_file | sed -n '/^# Broadband Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'LAF90.0%' | awk 'NR==3{print $1}'`
LAeq=`cat $Report_file | sed -n '/^# Broadband Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'LAeq' | awk 'NR==3{print $1}'`

#
Log_file=$dataFolder$prefix\_Log.txt
dos2unix -q $Log_file

#
Spectrum_Report_file=$dataFolder$prefix\_Spectrum_Report.txt
dos2unix -q $Spectrum_Report_file

Date=`cat $Spectrum_Report_file | sed -n '/^# Spectrum Results$/,/^$/{//b;p}' | awk 'NR==2||NR==4{print}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'Date'| awk  -F',' 'NR==2{print $1}'`
Time=`cat $Spectrum_Report_file | sed -n '/^# Spectrum Results$/,/^$/{//b;p}' | awk 'NR==2||NR==4{print}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'Time'| awk  -F',' 'NR==2{print $1}'`
Duration=`cat $Spectrum_Report_file | sed -n '/^# Spectrum Results$/,/^$/{//b;p}' | awk 'NR==2||NR==4{print}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'Duration'| awk  -F',' 'NR==2{print $1}'`
Receiver=`cat $Spectrum_Report_file | sed -n '/^# Spectrum Results$/,/^$/{//b;p}' | awk 'NR==2||NR==4{print}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'Comment'| awk  -F',' 'NR==2{print $1}'`
time_label="Date: $Date Time: $Time Duration: $Duration"
echo $time_label

LAeq_file=$dataFolder/LAeq
echo \#oneThirdOctave20to20k > $LAeq_file
echo $Receiver >> $LAeq_file
echo "$LAeq" >> $LAeq_file
LAeq=`cat $Spectrum_Report_file | sed -n '/^# Spectrum Results$/,/^$/{//b;p}' | awk 'NR==2||NR==4{print}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -c 13-43 | tr "," " " | awk 'NR==2{ print}'| fmt -1`
echo "$LAeq" >> $LAeq_file

#
Timer=`cat $Log_file | sed -n '/^# Broadband Log Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'Timer' | awk -F':' 'NR>2{print $1*3600+$2*60+$3}'`
LAFT3=`cat $Log_file | sed -n '/^# Broadband Log Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'LAFT3' | awk 'NR>2{print $1}'` 

LAF_file=$dataFolder/LAF
echo \#$time_label > $LAF_file
echo Receiver = $Receiver >> $LAF_file
echo LAF90 = $LAF90 >> $LAF_file
echo LAFmin = $LAFmin >> $LAF_file
echo LAFmax = $LAFmax >> $LAF_file
echo Timer LAFT3 >> $LAF_file
paste <(echo "$Timer") <(echo "$LAFT3") --delimiters ' '  | grep -v "\-\.\-" >> $LAF_file
