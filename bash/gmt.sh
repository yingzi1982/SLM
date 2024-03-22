#!/bin/bash

folder=$1

cd ../gmt/

if false; then 
./plotColorbar.sh $folder
fi

if true; then 
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
  xlabel='Statistical indices'
  xrange=1/9
  ylabel='LAF (dB)'
  yrange=0/80/10
  thickness=0.5
  colorSegmentation=officeNoiseColorSegmentation
  #colorSegmentation=no
  ./plotBar.sh $name $folder $width $height $thickness "$xlabel" $xrange "$ylabel" $yrange $colorSegmentation
done
fi

if true; then
for name in `find $folder -name "LAFT3_*"  '!' -name '*.svg' '!' -name '*.emf' '!' -name '*.pdf'  -exec basename {} \;`; do
  #echo "plotting LAFT3 time"
  duration_in_minute=60

  width=14c
  height=4c
  #xlabel="Time (m), from $startTime"
  xlabel="Time (m)"
  xrange=0/$duration_in_minute/10
  ylabel='LAFT3 (dB)'
  yrange=0/80/10
  #lineStyle=thin,black
  lineStyle=thin,darkgray
  colorSegmentation=officeNoiseColorSegmentation
  #colorSegmentation=no
  ./plotLine.sh $name $folder $width $height "$xlabel" $xrange "$ylabel" $yrange $lineStyle $colorSegmentation
done
fi

if true; then 
for name in `find $folder -name "LAeqSegmentation"  '!' -name '*.svg' '!' -name '*.emf' '!' -name '*.pdf'  -exec basename {} \;`; do
 header=`cat $folder$name | head -n 1 | cut -d "#" -f2`
 #delimiter='00|12|END'
 delimiter='00|END'
 delimiterLineNumbering=`cat $header | awk '{print $3}' | egrep -n $delimiter | awk '{print $1}' FS=":"`

elementName=`cat $folder$name | awk 'NR==2{print}'`

for i in $(seq 1 $((`echo "$delimiterLineNumbering" | wc -l` - 1)));do
startLineNumbering=`echo "$delimiterLineNumbering" | awk -v i="$i" 'NR==i{print}'`
endLineNumbering=`echo "$delimiterLineNumbering" | awk -v i="$i" 'NR==(i+1){print}'`
startTimeLabel=`cat $header | awk -v startLineNumbering="$startLineNumbering" 'NR==startLineNumbering{print $3}'`
endTimeLabel=`cat $header | awk -v endLineNumbering="$endLineNumbering" 'NR==endLineNumbering{print $3}'`

xrange=$startLineNumbering/$(($endLineNumbering-1))
width=7c
height=4c
#name=LAeq
xlabel='Time (h)'
ylabel='LAeq (dB)'
yrange=0/60/10
thickness=1
colorSegmentation=officeNoiseColorSegmentation
#colorSegmentation=no
./plotBar.sh $name $folder $width $height $thickness "$xlabel" $xrange "$ylabel" $yrange $colorSegmentation

mv $folder$name\_$elementName.emf $folder$name\_$elementName\_$startTimeLabel-$endTimeLabel.emf
mv $folder$name\_$elementName.pdf $folder$name\_$elementName\_$startTimeLabel-$endTimeLabel.pdf
done
done
fi
