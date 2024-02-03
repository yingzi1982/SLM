#!/usr/bin/env bash
rm -f gmt.conf
rm -f gmt.history
#gmt set MAP_FRAME_TYPE plain
#gmt set MAP_FRAME_PEN thin
gmt set FONT 10p,Helvetica,black
gmt set FONT_ANNOT 10p,Helvetica,black
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

xannots=`cat $originalxy | head -n 1 | cut -d "#" -f2`

xmin=`echo $xrange | awk -F'/' '{print $1-0.5}'`
xmax=`echo $xrange | awk -F'/' '{print $2+0.5}'`

ymin=`echo $yrange | awk -F'/' '{print $1}'`
ymax=`echo $yrange | awk -F'/' '{print $2}'`

yInterval=`echo $yrange | awk -F'/' '{print $3}'`
yHalfInterval=`echo $yInterval/2 | bc -l`

nameList=`cat $originalxy | awk 'NR==2{print}'`
nameListLength=`echo $nameList | awk '{print NF}'`

xy=`paste <(cat $xannots | awk '{print $1}') <(awk 'NR>2{print}' $originalxy) --delimiters ' '`

region=$xmin/$xmax/$ymin/$ymax

for i in $(seq 1 $nameListLength)
do
elementName=`echo $nameList | awk -v i="$i" '{print $(i)}'`
fig=$figFolder$name\_$elementName
gmt begin $fig
echo "$xy" | awk -v i="$i" 'NR==1{print $1, $(i+1)}' | gmt plot -J$projection -Bxc$xannots+a-45+l"$xlabel" -Bya$yInterval\f$yHalfInterval\g$yHalfInterval+l"$ylabel" -BWSne -R$region -Sb1ub0 -Gorange -W1p
echo "$xy" | awk -v i="$i" 'NR>=2{print $1, $(i+1)}' | gmt plot -Sb1ub0 -Gyellow -W1p

echo $xmax $ymax RT $elementName | gmt text -Dj2p/2p -F+fblack+j -N -G240/255/240
  
gmt end
inkscape $fig\.pdf --export-filename=$fig\.emf &>/dev/null
#pdf2svg  $fig\.pdf $fig\.svg
done
#rm -f gmt.conf
#rm -f gmt.history
