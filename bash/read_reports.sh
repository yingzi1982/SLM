#!/bin/bash

folderName=$1
prefix=`echo $folderName | awk -F'/' '{print $(NF-1)}'`

dataFolder=$folderName
receiver_label=`./read_receiver_label.sh $dataFolder`

Log_file=$dataFolder$prefix\_Log.txt
dos2unix -q $Log_file

Report_file=$dataFolder$prefix\_Report.txt
dos2unix -q $Report_file

Spectrum_Report_file=$dataFolder$prefix\_Spectrum_Report.txt
dos2unix -q $Spectrum_Report_file

Log_file_data_section=`cat $Log_file | sed -n '/^# Broadband Log Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]'`
Report_file_data_section=`cat $Report_file | sed -n '/^# Broadband Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]'`
Spectrum_Log_file_data_section=`cat $Spectrum_Report_file | sed -n '/^# Spectrum Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]'`
#---------------------------------------------------------------------------------------

DateTotal=`echo "$Log_file_data_section" | csvcut -Sc 'Date' | awk 'NR>2{print}'` 
TimeTotal=`echo "$Log_file_data_section" | csvcut -Sc 'Time' | awk 'NR>2{print}'` 
DateAndTimeTotal=`paste <(echo "$DateTotal") <(echo "$TimeTotal") --delimiters 'T'`
LAFT3Total=`echo "$Log_file_data_section" | csvcut -Sc 'LAFT3' | awk 'NR>2{print}'` 

time_segmentation_number=$(expr `echo "$Report_file_data_section"| wc -l` - 2)

DateSegmentation=`echo "$Report_file_data_section" | csvcut -Sc 'Date' | awk 'NR>2{print}'`
TimeSegmentation=`echo "$Report_file_data_section" | csvcut -Sc 'Time' | awk 'NR>2{print}'`
DurationSegmentation=`echo "$Report_file_data_section" | csvcut -Sc 'Duration' | awk 'NR>2{print}'`
DateAndTimeSegmentation=`paste <(echo "$DateSegmentation") <(echo "$TimeSegmentation") --delimiters 'T'`

#---------------------------------------------------------------------------------------

#for nameSegmentation in LAeq; do
for nameSegmentation in LAeq  "LAF10.0%" "LAF90.0%"; do
segmentation=`echo "$Report_file_data_section" | csvcut -Sc "$nameSegmentation" | awk 'NR>2{print}'`
#newNameSegmentation=`echo $nameSegmentation | awk -F'.' '{print $1}'`
newNameSegmentation=`echo $nameSegmentation | sed "s/\"/s/g"`
newNameSegmentation=`echo $nameSegmentation | sed "s/\'/m/g"`
newNameSegmentation=`echo $nameSegmentation | sed "s/.0%//g"`

segmentation_file=$dataFolder/$newNameSegmentation\Segmentation
echo $receiver_label > $segmentation_file
paste <(echo "$DateAndTimeSegmentation") <(echo "$segmentation") --delimiters ' ' >> $segmentation_file
done

#---------------------------------------------------------------------------------------

for n in $(seq 1 $time_segmentation_number)
do

Date=`echo "$DateSegmentation" | awk -v n="$n" 'NR==n{print}'`
Time=`echo "$TimeSegmentation" | awk -v n="$n" 'NR==n{print}'`
DateAndTime=`echo "$DateAndTimeSegmentation" | awk -v n="$n" 'NR==n{print}'`
#Duration=`echo "$DurationSegmentation" | awk -v n="$n" 'NR==n{print}'`
Duration=01:00:00 #uniform duration
DurationHH=`echo $Duration | awk -F':' '{print $1}'`
DurationMM=`echo $Duration | awk -F':' '{print $2}'`
DurationSS=`echo $Duration | awk -F':' '{print $3}'`

DateLabel=$Date
TimeLabel=`echo $Time | sed "s/:/-/g"`
DurationLabel=`echo $Duration | sed "s/:/-/g"`

timeStampLabel=$DateLabel\T$TimeLabel\D$DurationLabel

#----------------------------------------------------------------
LAFT3_file=$dataFolder/LAFT3\_$timeStampLabel

startTime=$DateAndTime
endTime=`date -d "$startTime $DurationHH hours $DurationMM minutes $DurationSS seconds" +"%Y-%m-%dT%H:%M:%S"`

echo $receiver_label > $LAFT3_file

paste <(echo "$DateAndTimeTotal") <(echo "$LAFT3Total") --delimiters ' '  | awk -v startTime="$startTime" -v endTime="$endTime" '($1>=startTime) && ($1<endTime){print}' | grep -v "\-\.\-" | awk 'NR%3==1{print}'>> $LAFT3_file

#---------------------------------------------------------------------------------------
LAF_file=$dataFolder/LAF\_$timeStampLabel

LAFmax=`echo "$Report_file_data_section" | csvcut -Sc 'LAFmax' | awk 'NR>2{print}' | awk -v n="$n" 'NR==n{print}'`
LAF1=`echo "$Report_file_data_section" | csvcut -Sc 'LAF1.0%' | awk 'NR>2{print}' | awk -v n="$n" 'NR==n{print}'`
LAF5=`echo "$Report_file_data_section" | csvcut -Sc 'LAF5.0%' | awk 'NR>2{print}' | awk -v n="$n" 'NR==n{print}'`
LAF10=`echo "$Report_file_data_section" | csvcut -Sc 'LAF10.0%' | awk 'NR>2{print}' | awk -v n="$n" 'NR==n{print}'`
LAF50=`echo "$Report_file_data_section" | csvcut -Sc 'LAF50.0%' | awk 'NR>2{print}' | awk -v n="$n" 'NR==n{print}'`
LAF90=`echo "$Report_file_data_section" | csvcut -Sc 'LAF90.0%' | awk 'NR>2{print}' | awk -v n="$n" 'NR==n{print}'`
LAF95=`echo "$Report_file_data_section" | csvcut -Sc 'LAF95.0%' | awk 'NR>2{print}' | awk -v n="$n" 'NR==n{print}'`
LAF99=`echo "$Report_file_data_section" | csvcut -Sc 'LAF99.0%' | awk 'NR>2{print}' | awk -v n="$n" 'NR==n{print}'`
LAFmin=`echo "$Report_file_data_section" | csvcut -Sc 'LAFmin' | awk 'NR>2{print}' | awk -v n="$n" 'NR==n{print}'`

echo -en \#LAFIndicators'\n'$receiver_label'\n'$LAFmax'\n'$LAF1'\n'$LAF5'\n'$LAF10'\n'$LAF50'\n'$LAF90'\n'$LAF95'\n'$LAF99'\n'$LAFmin > $LAF_file

#----------------------------------------------------------------
LAeq_file=$dataFolder/LAeq\_$timeStampLabel

LAeq=`echo "$Report_file_data_section" | csvcut -Sc 'LAeq' | awk 'NR>2{print}' | awk -v n="$n" 'NR==n{print}'`
echo \#oneThirdOctave20to20k > $LAeq_file
echo $receiver_label >> $LAeq_file
echo "$LAeq" >> $LAeq_file

LAeq_spectrum=`echo "$Spectrum_Log_file_data_section" | awk 'NR>3{print}' | csvcut -c 13-43 | tr "," " " | awk -v n="$n" 'NR==n{ print}' | fmt -1` 
echo "$LAeq_spectrum" >> $LAeq_file

done
