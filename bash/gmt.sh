#!/bin/bash

folder=$1

cd ../gmt/

if false; then 
./plotColorbar.sh $folder
fi

if false; then 
for name in `find $folder -name "LAeq_*"  '!' -name '*.svg' '!' -name '*.emf' '!' -name '*.pdf' -exec basename {} \;`; do
  #echo "plotting q"
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

if false; then 
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
