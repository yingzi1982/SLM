#!/usr/bin/env bash
rm -f gmt.conf
rm -f gmt.history
#gmt set MAP_FRAME_TYPE plain
#gmt set MAP_FRAME_PEN thin
gmt set FONT 8p,Helvetica,black
gmt set FONT_ANNOT 8p,Helvetica,black
#--------------------------------------------------------------------


folder=$1
figFolder=$folder


cptFile=office.cpt
cat > $cptFile <<END
0	blue	1	blue	; < 40 Excellent
1	green	2	green	;40-45 Good
2	yellow	3	yellow	;45-55 Poor
3	red	4	red	; > 55 Awful
B	black
F	white
END

fig=$figFolder\officeNoiseLevelColorbar

gmt begin $fig
gmt colorbar -C$cptFile  -Dx20/13+w04/0.5+jML+ef -L0.1 -By+L"Noise level (dBA)"
gmt end
rm -f $cptFile

inkscape $fig\.pdf --export-filename=$fig\.emf &>/dev/null
#pdf2svg  $fig\.pdf $fig\.svg
#rm -f gmt.conf
#rm -f gmt.history
