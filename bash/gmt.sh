#!/bin/bash

folder=$1

cd ../gmt/

if false; then 
./plotColorbar.sh $folder
fi

if false; then 
for name in `find $folder -name "LAeq_*"  '!' -name '*.svg' '!' -name '*.emf' '!' -name '*.pdf' -exec basename {} \;`; do
  #echo "plotting LAeq"
  width=7c
  height=4c
  #name=LAeq
  xlabel='Frequency (Hz)'
  xrange=1/32
  ylabel='LAeq (dB)'
  yrange=0/60/10
  thickness=1
  colorSegmentation=officeNoiseColorSegmentation
  #colorSegmentation=no
  ./plotBar.sh $name $folder $width $height $thickness "$xlabel" $xrange "$ylabel" $yrange $colorSegmentation
done
fi

if true; then 
for name in `find $folder -name "LAF_*"  '!' -name '*.svg' '!' -name '*.emf' '!' -name '*.pdf'  -exec basename {} \;`; do
  #echo "plotting LAF indicators"
  width=7c
  height=4c
  #name=LAF
  #xlabel='Statistical indices'
  xlabel='Percentile (%)'
  xrange=1/9
  ylabel='LAF (dB)'
  yrange=0/80/10
  thickness=0.5
  colorSegmentation=officeNoiseColorSegmentation
  #colorSegmentation=no
  ./plotBar.sh $name $folder $width $height $thickness "$xlabel" $xrange "$ylabel" $yrange $colorSegmentation
done
fi

if false; then
for name in `find $folder -name "LAFT3_*"  '!' -name '*.svg' '!' -name '*.emf' '!' -name '*.pdf'  -exec basename {} \;`; do
  #echo "plotting LAFT3 time"
  duration=`echo $name | awk -F'_' '{print $2}' | awk -F'T' '{print $2}' | awk -F'D' '{print $2}' | sed "s/-/:/g"`
  durationHH=`echo $duration | awk -F':' '{print $1}'`
  durationMM=`echo $duration | awk -F':' '{print $2}'`
  durationSS=`echo $duration | awk -F':' '{print $3}'`

  date=`echo $name | awk -F'_' '{print $2}' | awk -F'T' '{print $1}'`
  dateLabel=`date -d "$date" +"%A, %b %d, %Y"`
  startTime=`echo $name | awk -F'_' '{print $2}' | awk -F'T' '{print $2}' | awk -F'D' '{print $1}' | sed "s/-/:/g"`
  startDateAndTime=$date\T$startTime
  endDateAndTime=`date -d "$startDateAndTime $durationHH hours $durationMM minutes $durationSS seconds" +"%Y-%m-%dT%H:%M:%S"`

  width=14c
  height=4c
  xlabel="Time (hh:mm), on $dateLabel"
  xrange=$startDateAndTime/$endDateAndTime/15M/5m
  ylabel='LAFT3 (dB)'
  yrange=0/80/10/5
  #lineStyle=thin,black
  lineStyle=thin,darkgray
  colorSegmentation=officeNoiseColorSegmentation
  #colorSegmentation=no
  ./plotLine.sh $name $folder $width $height "$xlabel" $xrange "$ylabel" $yrange $lineStyle $colorSegmentation
done
fi

if false; then 
for nameSegmentation in LAeq LAF10 LAF90; do
fullPartName=$nameSegmentation\Segmentation

duration=24:00:00
durationHH=`echo $duration | awk -F':' '{print $1}'`
durationMM=`echo $duration | awk -F':' '{print $2}'`
durationSS=`echo $duration | awk -F':' '{print $3}'`
durationLabel=`echo $duration | sed "s/:/-/g"`

elementName=`cat $folder$fullPartName | awk 'NR==1{print}'`

date=`cat $folder$fullPartName | awk -F'T' 'NR==2{print $1}'`
dateLabel=`date -d "$date" +"%A, %b %d, %Y"`

for startTime in 00:00:00; do

startDateAndTime=$date\T$startTime
endDateAndTime=`date -d "$startDateAndTime $durationHH hours $durationMM minutes $durationSS seconds" +"%Y-%m-%dT%H:%M:%S"`

startDateAndTimeLabel=`echo $startDateAndTime | sed "s/:/-/g"`

cutPart=`cat $folder$fullPartName  | awk -v startDateAndTime="$startDateAndTime" -v endDateAndTime="$endDateAndTime" '($1>=startDateAndTime) && ($1<endDateAndTime) && (NR>1){print}'`

cutLength=`echo "$cutPart" | wc -l`

timeLabel=`echo "$cutPart" | awk '{print $1}' | awk -F'T' '{print $2}' | awk -F':' '{print $1}'`

header_file=$fullPartName
>$header_file
for n in $(seq 1 $cutLength);do
echo $n ag `echo "$timeLabel" | awk -v n="$n" 'NR==n{print}'` yellow >> $header_file
done

cutPartName=$fullPartName\_$startDateAndTimeLabel\D$durationLabel
cutPart_file=$folder$cutPartName
echo $header_file > $cutPart_file
echo $elementName >> $cutPart_file 
echo "$cutPart" | awk '{print $2}' >> $cutPart_file

xrange=1/$cutLength
width=10c
height=4c
name=$cutPartName
xlabel="Time (hh), on $dateLabel"
ylabel="$nameSegmentation (dB)"
yrange=0/60/10
thickness=1
colorSegmentation=officeNoiseColorSegmentation
#colorSegmentation=no
./plotBar.sh $name $folder $width $height $thickness "$xlabel" $xrange "$ylabel" $yrange $colorSegmentation

done
done
fi
