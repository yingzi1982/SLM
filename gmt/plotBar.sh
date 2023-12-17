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

yHalfInterval=`echo $yInterval/2 | bc -l`
LAF90=`awk 'NR==1{print $3}' $originalxy`

cat << EOF >| LAF90.txt
$xmin $LAF90
$xmax $LAF90
EOF

gmt begin $fig

awk 'NR==2{print $1, $3}' $originalxy | gmt plot -J$projection -Bxcxannots.txt+a-45+l"$xlabel" -Bya$yInterval\f$yHalfInterval\g$yHalfInterval+l"$ylabel" -BWSne+glightgray -R$region -Sb1ub0 -Gred -W.5p
awk 'NR>=3{print $1, $3}' $originalxy | gmt plot -Sb1ub0 -Gorange -W.5p
gmt plot LAF90.txt -W1p,blue,..

gmt end

rm -f gmt.conf
rm -f gmt.history
