#!/usr/bin/env bash
#gmt defaults > gmt.conf
rm -f gmt.conf
rm -f gmt.history
#gmt set MAP_FRAME_TYPE plain
#gmt set MAP_FRAME_PEN thin
gmt set FONT 12p,Helvetica,black
#--------------------------------------------------------------------

name=${1}

xlabel=${2}
xunit=${3}
#xrange=${4}

ylabel=${4}
yunit=${5}
#yrange=${7}

lineColor=blue
fillColor=lightgray

backupFolder=../backup/
figFolder=../figures/
mkdir -p $figFolder
fig=$figFolder$name

originalxy=$backupFolder$name

width=2.2
height=0.68
projection=X$width\i/$height\i

#echo $xmin $xmax $ymin $ymax
#echo -R$xmin/$xmax/$ymin/$ymax
gmt begin $fig

#awk '{print $1 $2}' $originalxy | gmt plot -J$projection -Ra -Bxaf+l"$xlabel ($xunit)" -Byaf+l"$ylabel ($yunit)" -G$fillColor -Wthin,$lineColor
awk '{print $1 $2}' $originalxy | gmt plot -R0/10/-2/2 -J$projection -Glightgray -Wthin,$lineColor -Ba

gmt end

rm -f gmt.conf
rm -f gmt.history
