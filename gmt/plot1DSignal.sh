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

yrange=${5}
ytick=${6}
ylabel=${7}

line=thinnest,black
fill=lightgray
width=2.2i
height=0.78i

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
sub=2
xtickSub=`echo "(($xtick)/$sub)" | bc -l`
ytickSub=`echo "(($ytick)/$sub)" | bc -l`

region=$xmin/$xmax/$ymin/$ymax

gmt begin $fig

gmt plot $originalxy -J$projection -R$region -Bxa$xtick\f$xtickSub+l"$xlabel" -Bya$ytick\f$ytickSub+l"$ylabel" -G$fill -W$line

gmt end

rm -f gmt.conf
rm -f gmt.history
