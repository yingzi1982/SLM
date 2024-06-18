#!/usr/bin/env bash
rm -f gmt.conf
rm -f gmt.history
#gmt set MAP_FRAME_TYPE plain
#gmt set MAP_FRAME_PEN thin
gmt set FONT 11p,Helvetica,black
gmt set FONT_ANNOT 11p,Helvetica,black
#--------------------------------------------------------------------


folder=$1
figFolder=$folder


cpt=officeNoiseColorSegmentation

fig=$figFolder\officeNoiseLevelColorbar

gmt begin $fig
gmt colorbar -C$cpt  -Dx20/13+w04/0.5+jML+ef -L0.1 -By+L"Noise exposure level (dBA)"
gmt end

pdf2svg  $fig\.pdf $fig\.svg
inkscape $fig\.svg --export-filename=$fig\.emf &>/dev/null
rm -f $fig\.svg
#rm -f gmt.conf
#rm -f gmt.history
