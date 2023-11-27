#!/usr/bin/env bash
#gmt defaults > gmt.conf
rm -f gmt.conf
rm -f gmt.history
#gmt set MAP_FRAME_TYPE plain
#gmt set MAP_FRAME_PEN thin
gmt set FONT 12p,Helvetica,black
#--------------------------------------------------------------------

name=${1}

xrange=${2}
xtick=${3}
xlabel=${4}
xunit=${5}

yrange=${6}
ytick=${7}
ylabel=${8}
yunit=${9}

lineColor=black
fillColor=lightgray

backupFolder=../backup/
figFolder=../figures/
mkdir -p $figFolder
fig=$figFolder$name

originalxy=$backupFolder$name

width=2.2
height=0.68
projection=X$width\i/$height\i

xmin=`echo $xrange | awk '{print $1}'`
xmax=`echo $xrange | awk '{print $2}'`
ymin=`echo $yrange | awk '{print $1}'`
ymax=`echo $yrange | awk '{print $2}'`
sub=2
xtickSub=`echo "(($xtick)/$sub)" | bc -l`
ytickSub=`echo "(($ytick)/$sub)" | bc -l`

region=$xmin/$xmax/$ymin/$ymax

echo $projection
echo $region

gmt begin $fig

awk '{print $1 $2}' $originalxy | gmt plot -J$projection -R$region -Bxa$xtick\f$xtickSub+l"$xlabel ($xunit)" -Bya$ytick\f$ytickSub+l"$ylabel ($yunit)" -G$fillColor #-Wthin,$lineColor

gmt end

rm -f gmt.conf
rm -f gmt.history
