#!/bin/bash

folder=$1

cd ../gmt/

if true; then 
  #echo "plotting LAeq"
  width=7c
  height=4c
  name=LAeq
  xlabel='Freq (Hz)'
  xrange=1/32
  ylabel='LAeq (dB)'
  yrange=0/60/10
  ./plotBar.sh $name $folder $width $height "$xlabel" $xrange "$ylabel" $yrange
fi

if true; then
  #echo "plotting LAF"
  width=7c
  height=4c
  name=LAF
  xlabel='Time (s)'
  xrange=0/900/120
  ylabel='LAFT3 (dB)'
  yrange=20/80/10
  ./plotLAF.sh $name $folder $width $height "$xlabel" $xrange "$ylabel" $yrange
fi
