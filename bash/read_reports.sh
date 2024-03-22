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

DateTotal=`cat $Log_file | sed -n '/^# Broadband Log Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'Date' | awk 'NR>2{print $1}'` 
TimeTotal=`cat $Log_file | sed -n '/^# Broadband Log Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'Time' | awk 'NR>2{print $1}'` 
DateAndTimeTotal=`paste <(echo "$DateTotal") <(echo "$TimeTotal") --delimiters 'T'`
DateAndTimeTotalInSeconds=`date -f <(echo "$DateAndTimeTotal") "+%s"`
LAFT3Total=`cat $Log_file | sed -n '/^# Broadband Log Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -Sc 'LAFT3' | awk 'NR>2{print $1}'`

data_section=`cat $Report_file | sed -n '/^# Broadband Results$/,/^$/{//b;p}' | tr '\t' ',' | tr -d '[:blank:]'`
time_segmentation_number=$(expr `echo "$data_section"| wc -l` - 2)

LAeqSegmentation_file=$dataFolder/LAeqSegmentation
echo \#LAeqSegmentation > $LAeqSegmentation_file
echo $receiver_label >>$LAeqSegmentation_file
echo "$data_section" | csvcut -Sc 'LAeq' | awk 'NR>2{print $1}'>>$LAeqSegmentation_file
echo "0" >>$LAeqSegmentation_file
header_file=../gmt/LAeqSegmentation
> $header_file

for n in $(seq 1 $time_segmentation_number)
do
ln=$((n+2))

Date=`echo "$data_section" | csvcut -Sc 'Date' | awk -v ln="$ln" 'NR==ln{print $1}'`
Time=`echo "$data_section" | csvcut -Sc 'Time' | awk -v ln="$ln" 'NR==ln{print $1}'`
DateAndTime=`paste <(echo "$Date") <(echo "$Time") --delimiters 'T'`
Duration=`echo "$data_section" | csvcut -Sc 'Duration' | awk -v ln="$ln" 'NR==ln{print $1}'| awk -F'.' '{print $1}'`
DurationHH=`echo $Duration | awk -F':' '{print $1}'`
DurationMM=`echo $Duration | awk -F':' '{print $2}'`
DurationSS=`echo $Duration | awk -F':' '{print $3}'`

startTime=$DateAndTime
endTime=`date -d "$startTime $DurationHH hours $DurationMM minutes $DurationSS seconds" +"%Y-%m-%dT%H:%M:%S"`

DateLabel=$Date
TimeLabel=`echo $Time | sed "s/:/-/g"`
DurationLabel=`echo $Duration | sed "s/:/-/g"`
timeStampLabel=$DateLabel\T$TimeLabel\D$DurationLabel


HH=`echo $TimeLabel | awk -F'-' '{print $1}'`
MM=`echo $TimeLabel | awk -F'-' '{print $2}'`
SS=`echo $TimeLabel | awk -F'-' '{print $3}'`
#echo $n ag $HH:$MM yellow >> $header_file
echo $n ag $HH yellow >> $header_file

LAFmax=`echo "$data_section" | csvcut -Sc 'LAFmax' | awk -v ln="$ln" 'NR==ln{print $1}'`
LAF1=`echo "$data_section" | csvcut -Sc 'LAF1.0%' | awk -v ln="$ln" 'NR==ln{print $1}'`
LAF5=`echo "$data_section" | csvcut -Sc 'LAF5.0%' | awk -v ln="$ln" 'NR==ln{print $1}'`
LAF10=`echo "$data_section" | csvcut -Sc 'LAF10.0%' | awk -v ln="$ln" 'NR==ln{print $1}'`
LAF50=`echo "$data_section" | csvcut -Sc 'LAF50.0%' | awk -v ln="$ln" 'NR==ln{print $1}'`
LAF90=`echo "$data_section" | csvcut -Sc 'LAF90.0%' | awk -v ln="$ln" 'NR==ln{print $1}'`
LAF95=`echo "$data_section" | csvcut -Sc 'LAF95.0%' | awk -v ln="$ln" 'NR==ln{print $1}'`
LAF99=`echo "$data_section" | csvcut -Sc 'LAF99.0%' | awk -v ln="$ln" 'NR==ln{print $1}'`
LAFmin=`echo "$data_section" | csvcut -Sc 'LAFmin' | awk -v ln="$ln" 'NR==ln{print $1}'`

LAF_file=$dataFolder/LAF\_$timeStampLabel
echo -en \#LAFIndicators'\n'$receiver_label'\n'$LAFmax'\n'$LAF1'\n'$LAF5'\n'$LAF10'\n'$LAF50'\n'$LAF90'\n'$LAF95'\n'$LAF99'\n'$LAFmin > $LAF_file

#----------------------------------------------------------------
LAeq=`echo "$data_section" | csvcut -Sc 'LAeq' | awk -v ln="$ln" 'NR==ln{print $1}'`
LAeq_file=$dataFolder/LAeq\_$timeStampLabel
echo \#oneThirdOctave20to20k > $LAeq_file
echo $receiver_label >> $LAeq_file
echo "$LAeq" >> $LAeq_file

LAeq_spectrum=`cat $Spectrum_Report_file | sed -n '/^# Spectrum Results$/,/^$/{//b;p}' | awk 'NR>=2{print}' | tr '\t' ',' | tr -d '[:blank:]' | csvcut -c 13-43 | tr "," " " | awk -v ln="$ln" 'NR==ln{ print}'| fmt -1`
echo "$LAeq_spectrum" >> $LAeq_file

#----------------------------------------------------------------
LAFT3_segment_file=$dataFolder/LAFT3\_$timeStampLabel
echo $receiver_label > $LAFT3_segment_file

startTimeInSeconds=`date -f <(echo "$startTime") "+%s"`
endTimeInSeconds=`date -f <(echo "$endTime") "+%s"`
paste <(echo "$DateAndTimeTotalInSeconds") <(echo "$LAFT3Total") --delimiters ' '  | awk -v startTimeInSeconds="$startTimeInSeconds" -v endTimeInSeconds="$endTimeInSeconds" '($1>=startTimeInSeconds) && ($1<=endTimeInSeconds){print}' | awk '{if(NR==1){zeroTime=$1}{print ($1-zeroTime)/60,$2}}' | grep -v "\-\.\-" | awk 'NR%3==1{print}'>> $LAFT3_segment_file
done

echo $(($time_segmentation_number+1)) ag END yellow >> $header_file
