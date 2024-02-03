#!/bin/bash

wavFolder=$1
timeStepResample=$2
freqStepResample=$3

./octave.sh read_wav_file.m "$wavFolder $timeStepResample $freqStepResample"
