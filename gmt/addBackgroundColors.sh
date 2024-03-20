#colorSegmentationFile=officeNoiseColorSegmentation
level1=40
level2=45
level3=55

polygonFile=polygon.txt

xmin_region=`echo $region | awk -F'/' '{print $1}'`
xmax_region=`echo $region | awk -F'/' '{print $2}'`
ymin_region=`echo $region | awk -F'/' '{print $3}'`
ymax_region=`echo $region | awk -F'/' '{print $4}'`

cat <<- EOF > $polygonFile
$xmin_region $ymin_region
$xmax_region $ymin_region
$xmax_region $level1
$xmin_region $level1
EOF
fillColor=blue
gmt plot $polygonFile -G$fillColor

cat <<- EOF > $polygonFile
$xmin_region $level1
$xmax_region $level1
$xmax_region $level2
$xmin_region $level2
EOF
fillColor=green
gmt plot $polygonFile -G$fillColor

cat <<- EOF > $polygonFile
$xmin_region $level2
$xmax_region $level2
$xmax_region $level3
$xmin_region $level3
EOF
fillColor=yellow
gmt plot $polygonFile -G$fillColor

cat <<- EOF > $polygonFile
$xmin_region $level3
$xmax_region $level3
$xmax_region $ymax_region
$xmin_region $ymax_region
EOF
fillColor=red
gmt plot $polygonFile -G$fillColor

rm -f $polygonFile
