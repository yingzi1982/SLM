#!/bin/bash
#./create_level_difference.sh receiver ../data/situation10/ ../data/situation12/

dataName=$1
dataFolder1=$2
dataFolder2=$3

./octave.sh generate_level_difference.m "$dataName $dataFolder1 $dataFolder2"

