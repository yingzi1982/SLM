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

thickness=${5}

xlabel=${6}
xrange=${7}

ylabel=${8}
yrange=${9}

colorSegmentation=${10}
colorSegmentation=`echo $colorSegmentation|tr -d ' '` 

dataFolder=$folder
originalxy=$dataFolder$name
dos2unix -q $originalxy

figFolder=$folder
#mkdir -p $figFolder

projection=X$width/$height

xannotsFile=xannots.txt
header=`cat $originalxy | head -n 1 | cut -d "#" -f2`
cat $header | awk '{$NF=""}1' > $xannotsFile

color=`cat $header | awk '{print $NF}'`

xy=`paste <(cat $header | awk '{print $1}') <(awk 'NR>2{print}' $originalxy) --delimiters ' '`

xmin=`echo $xrange | awk -F'/' '{print $1}'`
xmax=`echo $xrange | awk -F'/' '{print $2}'`

ymin=`echo $yrange | awk -F'/' '{print $1}'`
ymax=`echo $yrange | awk -F'/' '{print $2}'`

yInterval=`echo $yrange | awk -F'/' '{print $3}'`
yHalfInterval=`echo $yInterval/2 | bc -l`

nameList=`cat $originalxy | awk 'NR==2{print}'`
nameListLength=`echo $nameList | awk '{print NF}'`

region=`echo $xmin-0.5 | bc -l`/`echo $xmax+0.5 | bc -l`/$ymin/$ymax
xmin_region=`echo $region | awk -F'/' '{print $1}'`
xmax_region=`echo $region | awk -F'/' '{print $2}'`
ymin_region=`echo $region | awk -F'/' '{print $3}'`
ymax_region=`echo $region | awk -F'/' '{print $4}'`

for i in $(seq 1 $nameListLength)
do
elementName=`echo $nameList | awk -v i="$i" '{print $(i)}'`
fig=$figFolder$name\_$elementName
gmt begin $fig
gmt basemap -J$projection -R$region -Bxc$xannotsFile+a-45+l"$xlabel" -Bya$yInterval\f$yHalfInterval\g$yHalfInterval+l"$ylabel" 

for j in $(seq $xmin $xmax)
do
element_x=`echo "$xy" | awk -v i="$i" -v j="$j" 'NR==j{print $1}'`
element_y=`echo "$xy" | awk -v i="$i" -v j="$j" 'NR==j{print $(i+1)}'`
if [ $colorSegmentation = "none" ] ||[ $colorSegmentation = "no" ]; then
jColor=`echo "$color" | awk -v j="$j" 'NR==j{print $1}' | tr -d ' '`
else
jColor=`cat  $colorSegmentation | awk -v element_y="$element_y" '{{if($1<=element_y&&$2>element_y) print $3}}' | tr -d ' '`
fi
echo $element_x $element_y | gmt plot -Sb$thickness\ub0 -G$jColor -W1p
done
if [ "$elementName" = "NoName" ] ;then
:
else
echo $xmax_region $ymax_region RT $elementName | gmt text -Dj2p/2p -F+fblack+j -N -G240/255/240
fi
gmt basemap -BWSne
gmt end

inkscape $fig\.pdf --export-filename=$fig\.emf &>/dev/null
#pdf2svg  $fig\.pdf $fig\.svg
done
rm -f $xannotsFile
#rm -f gmt.conf
#rm -f gmt.history
