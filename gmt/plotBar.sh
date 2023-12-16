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

xrange=${4}
xInterval=${5}
xlabel=${6}

yrange=${7}
yInterval=${8}
ylabel=${9}

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

awk '{print $1, $3}' $originalxy | gmt plot -Bx+l"$xlabel" -By+l"$ylabel" -BWSne+glightblue -R$region #-Gorange -W1p -T1 

gmt end

rm -f gmt.conf
rm -f gmt.history
