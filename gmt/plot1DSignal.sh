#!/usr/bin/env bash
#gmt defaults > gmt.conf
rm -f gmt.conf
rm -f gmt.history
#gmt set MAP_FRAME_TYPE plain
#gmt set MAP_FRAME_PEN thin
gmt set FONT 12p,Helvetica,black
#--------------------------------------------------------------------

name=${1}
resampleRate=${2}

xlabel=${3}
xunit=${4}
xrange=${5}
xtick=${6}

ylabel=${7}
yunit=${8}
yrange=${9}
ytick=${10}

backupFolder=../backup/
figFolder=../figures/
mkdir -p $figFolder
fig=$figFolder$name

originalxy=$backupFolder$name

xmin=`echo $xrange | awk '{print $1}'`
xmax=`echo $xrange | awk '{print $2}'`
ymin=`echo $yrange | awk '{print $1}'`
ymax=`echo $yrange | awk '{print $2}'`

region=$xmin/$xmax/$ymin/$ymax

width=2.2
height=0.68
projection=X$width\i/$height\i

gmt begin $fig

awk -v resampleRate="$resampleRate" 'NR%resampleRate==0 {print $1 $2}' $originalxy | gmt plot -J$projection -R$region -Bx$xtick+l"$xlabel ($xunit)" -By$ytick+l"$ylabel ($yunit)" -Gred -Wthin,black

gmt end

rm -f gmt.conf
rm -f gmt.history
