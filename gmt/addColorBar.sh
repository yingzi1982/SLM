widthValue=`echo $width|tr -d -c 0-9`
widthUnit=`echo $width|tr -d 0-9`
heightValue=`echo $height|tr -d -c 0-9`
heightUnit=`echo $height|tr -d 0-9`
colorbar_width=$heightValue
colorbar_height=0.16
colorbar_horizontal_position=`echo "$widthValue+0.1" | bc -l`
colorbar_vertical_position=`echo "$colorbar_width/2" | bc -l`
domain=$colorbar_horizontal_position$widthUnit/$colorbar_vertical_position$heightUnit/$colorbar_width$heightUnit/$colorbar_height$widthUnit
#echo $domain
#exit
#gmt colorbar -Dx$domain -Bxa1f0.5 -By+l"$scale$unit"
gmt colorbar -Coffice.cpt  -Dx$domain+w08/0.5+jML+ef -L0.1
echo "$xy" | gmt plot -W$lineStyle
