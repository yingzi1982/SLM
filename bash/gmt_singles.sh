#!/bin/bash

folder=$1
cd ../gmt/

if true; then 
./plotColorbar.sh $folder
fi

if true; then 
for name in LAF10 LAF90 LAeq; do
  #echo "plotting LAeq"
  width=2c
  height=4c
  #name=LAeq
  xlabel=' '
  xrange=1/2
  ylabel="$name (dB)"
  #if [ $name == "LAF10" ];
  #then
  #ylabel='Intrusive noise level'
  #fi
  yrange=0/60/10
  thickness=0.5
  colorSegmentation=officeNoiseColorSegmentation
  #colorSegmentation=no
  ./plotBar.sh $name $folder $width $height $thickness "$xlabel" $xrange "$ylabel" $yrange $colorSegmentation
done
fi
