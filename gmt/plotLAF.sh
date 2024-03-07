#!/usr/bin/env bash
rm -f gmt.conf
rm -f gmt.history
#gmt set MAP_FRAME_TYPE plain
#gmt set MAP_FRAME_PEN thin
gmt set FONT 8p,Helvetica,black
gmt set FONT_ANNOT 8p,Helvetica,black
#--------------------------------------------------------------------

name=${1}
folder=${2}

width=${3}
height=${4}

xlabel=${5}
xrange=${6}

ylabel=${7}
yrange=${8}

dataFolder=$folder
originalxy=$dataFolder$name
dos2unix -q $originalxy

figFolder=$folder
#mkdir -p $figFolder

projection=X$width/$height

xmin=`echo $xrange | awk -F'/' '{print $1}'`
xmax=`echo $xrange | awk -F'/' '{print $2}'`
xInterval=`echo $xrange | awk -F'/' '{print $3}'`
xHalfInterval=`echo $xInterval/2 | bc -l`

ymin=`echo $yrange | awk -F'/' '{print $1}'`
ymax=`echo $yrange | awk -F'/' '{print $2}'`
yInterval=`echo $yrange | awk -F'/' '{print $3}'`
yHalfInterval=`echo $yInterval/2 | bc -l`

receiverName=`cat $originalxy | grep Receiver | cut -d = -f 2 | xargs`

xy=`cat $originalxy | sed -n '/^Timer LAFT3$/,/^$/{//b;p}'`
LAF90=`cat $originalxy | grep LAF90 | cut -d = -f 2 | awk '{printf "%.0f\n",$1}' | xargs`
#cat << EOF >| LAF90.txt
#$xmin $LAF90
#$xmax $LAF90
#EOF

region=$xmin/$xmax/$ymin/$ymax

fig=$figFolder$name\_$receiverName\_$xmin-$xmax
gmt begin $fig
echo "$xy" | awk 'NR%3==0{print $1,$2}'| gmt plot -J$projection -R$region -Bxa$xInterval\f$xHalfInterval\g$xHalfInterval+l"$xlabel" -Bya$yInterval\f$yHalfInterval\g$yHalfInterval+l"$ylabel" -Wthin,brown
echo $xmax $ymax RT $receiverName | gmt text -Dj2p/2p -F+fblack+j -N -G240/255/240
echo $xmax $ymin RB "LAF90 = $LAF90 (dB)" | gmt text -Dj2p/4p -F+fblack+j -N -G240/255/240
#cat LAF90.txt | gmt plot  -Wthin,brown,...
gmt end
inkscape $fig\.pdf --export-filename=$fig\.emf &>/dev/null
#pdf2svg  $fig\.pdf $fig\.svg
#rm -f gmt.conf
#rm -f gmt.history
