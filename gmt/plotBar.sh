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
#LAFmin=`awk 'NR==1{print $3}' $originalxy`
LAF90=`awk 'NR==2{print $3}' $originalxy`
LAFmax=`awk 'NR==3{print $3}' $originalxy`

arrowStart_x=2
cat << EOF >| LAF90.txt
$arrowStart_x $LAF90 $xmin $LAF90 LM L@-AF90@-
EOF
cat << EOF >| LAFmax.txt
$arrowStart_x $LAFmax $xmin $LAFmax LM L@-AFmax@-
EOF

gmt begin $fig

awk 'NR==4{print $1, $3}' $originalxy | gmt plot -J$projection -Bxcxannots.txt+a-45+l"$xlabel" -Bya$yInterval\f$yHalfInterval\g$yHalfInterval+l"$ylabel" -BWSne+glightgray -R$region -Sb1ub0 -Gyellow -W.5p
awk 'NR>=5{print $1, $3}' $originalxy | gmt plot -Sb1ub0 -Gorange -W.5p

#echo 0 $LAFmax | gmt plot  -Ss0.02i -Gred -N -W0p
#echo 0 $LAF90 | gmt plot  -Ss0.02i -Ggreen -N -W0p

awk '{print $1, $2, $3, $4}' LAFmax.txt | gmt plot -N -Sv0.3c+s+e -Gred -W.5p,black
awk '{print $1, $2, $5, $6}' LAFmax.txt | gmt text -Dj2p/0 -F+fred+j -N

awk '{print $1, $2, $3, $4}' LAF90.txt | gmt plot -N -Sv0.3c+s+e -Gblue -W.5p,black
awk '{print $1, $2, $5, $6}' LAF90.txt | gmt text -Dj2p/0 -F+fblue+j -N


#gmt text -Dj10p/0 -F+fred+j -N LAFmax.txt

#gmt plot -Ss0.03i -Gblue -Wthinnest LAF90.txt
#gmt text -Dj10p/0 -F+fblue+j -N LAF90.txt

gmt end

rm -f gmt.conf
rm -f gmt.history
pdf2svg  $fig\.pdf $fig\.svg
