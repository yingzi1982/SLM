#!/usr/bin/env bash
rm -f gmt.conf
rm -f gmt.history
#gmt set MAP_FRAME_TYPE plain
#gmt set MAP_FRAME_PEN thin
gmt set FONT 11p,Helvetica,black
gmt set FONT_ANNOT 11p,Helvetica,black
#gmt set FORMAT_DATE_MAP "o dd" FORMAT_CLOCK_MAP hh:mm FONT_ANNOT_PRIMARY +9p

gmt set FORMAT_CLOCK_MAP hh:mm
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
cpt=${10}
cpt=`echo $cpt|tr -d ' '` 

dataFolder=$folder
originalxy=$dataFolder$name
dos2unix -q $originalxy

figFolder=$folder
#mkdir -p $figFolder

projection=X$width/$height

xmin=`echo $xrange | awk -F'/' '{print $1}'`
xmax=`echo $xrange | awk -F'/' '{print $2}'`
xPrimaryInterval=`echo $xrange | awk -F'/' '{print $3}'`
xSecondaryInterval=`echo $xrange | awk -F'/' '{print $4}'`

ymin=`echo $yrange | awk -F'/' '{print $1}'`
ymax=`echo $yrange | awk -F'/' '{print $2}'`
yPrimaryInterval=`echo $yrange | awk -F'/' '{print $3}'`
ySecondaryInterval=`echo $yrange | awk -F'/' '{print $4}'`

receiverName=`cat $originalxy | head -n 1 |tr -d ' '`

xy=`cat $originalxy | awk 'NR>1{print $1,$2}'`

region=$xmin/$xmax/$ymin/$ymax

fig=$figFolder$name\_$receiverName
gmt begin $fig
gmt basemap -J$projection -R$region  -Bxa$xPrimaryInterval\f$xSecondaryInterval\g$xSecondaryInterval+l"$xlabel" -Bya$yPrimaryInterval\f$ySecondaryInterval\g$ySecondaryInterval+l"$ylabel"

if [ -z "${10}" ]; then
:
else
xmin_polygon=$xmin
xmax_polygon=$xmax
while read line; do
ymin_polygon=`echo $line | awk '{print $1}'` 
ymax_polygon=`echo $line | awk '{print $3}'` 
color=`echo $line | awk '{print $2}'` 

cat <<- EOF > polygonFile
$xmin_polygon $ymin_polygon
$xmax_polygon $ymin_polygon
$xmax_polygon $ymax_polygon
$xmin_polygon $ymax_polygon
EOF
gmt plot polygonFile -G$color
rm -f polygonFile
done <$cpt
fi

echo "$xy" | gmt plot -W$lineStyle

if [ "$receiverName" = "NoName" ] ;then
:
else
echo $xmax $ymax RT $receiverName | gmt text -Dj2p/2p -F+fblack+j -N -G240/255/240
fi

gmt basemap -BWSne
gmt end
pdf2svg  $fig\.pdf $fig\.svg
inkscape $fig\.svg --export-filename=$fig\.emf &>/dev/null
rm -f $fig\.svg
#rm -f gmt.conf
#rm -f gmt.history
