#!/usr/bin/env bash
rm -f gmt.conf
rm -f gmt.history
#gmt set MAP_FRAME_TYPE plain
#gmt set MAP_FRAME_PEN thin
gmt set FONT 12p,Helvetica,black
#--------------------------------------------------------------------

name=${1}

width=${2}
height=${3}
line=${4}
fill=${5}

xrange=${6}
xInterval=${7}
xlabel=${8}

yrange=${9}
yInterval=${10}
ylabel=${11}

backupFolder=../backup/
figFolder=../figures/
mkdir -p $figFolder
fig=$figFolder$name

originalxy=$backupFolder$name

projection=X$width/$height

xmin=`echo $xrange | awk '{print $1}'`
xmax=`echo $xrange | awk '{print $2}'`
ymin=`echo $yrange | awk '{print $1}'`
ymax=`echo $yrange | awk '{print $2}'`

region=$xmin/$xmax/$ymin/$ymax

gmt begin $fig

gmt plot $originalxy -J$projection -R$region -Bsxcxannots.txt+l"$xlabel" -Bya$yInterval+l"$ylabel" $fill $line

gmt end

rm -f gmt.conf
rm -f gmt.history
