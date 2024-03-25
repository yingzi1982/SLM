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

lineStyle=${9}
colorSegmentation=${10}
colorSegmentation=`echo $colorSegmentation|tr -d ' '` 

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

receiverName=`cat $originalxy | head -n 1 |tr -d ' '`

xy=`cat $originalxy | awk 'NR>1{print $1,$2}'`

region=$xmin/$xmax/$ymin/$ymax

fig=$figFolder$name\_$receiverName
gmt begin $fig
gmt basemap -J$projection -R$region -Bxa$xInterval\f$xHalfInterval\g$xHalfInterval+l"$xlabel" -Bya$yInterval\f$yHalfInterval\g$yHalfInterval+l"$ylabel"

if [ $colorSegmentation = "none" ] || [ $colorSegmentation = "no" ]; then
:
else
xmin_polygon=$xmin
xmax_polygon=$xmax
while read line; do
ymin_polygon=`echo $line | awk '{print $1}'` 
ymax_polygon=`echo $line | awk '{print $2}'` 
color=`echo $line | awk '{print $3}'` 

cat <<- EOF > polygonFile
$xmin_polygon $ymin_polygon
$xmax_polygon $ymin_polygon
$xmax_polygon $ymax_polygon
$xmin_polygon $ymax_polygon
EOF
gmt plot polygonFile -G$color
rm -f polygonFile
done <$colorSegmentation
fi

echo "$xy" | gmt plot -W$lineStyle

if [ "$receiverName" = "NoName" ] ;then
:
else
echo $xmax $ymax RT $receiverName | gmt text -Dj2p/2p -F+fblack+j -N -G240/255/240
fi

gmt basemap -BWSne
gmt end
inkscape $fig\.pdf --export-filename=$fig\.emf &>/dev/null
#pdf2svg  $fig\.pdf $fig\.svg
#rm -f gmt.conf
#rm -f gmt.history
