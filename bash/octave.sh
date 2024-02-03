#!/bin/bash

octave_script=$1
input_parameters=$2

cd ../octave

./$octave_script $input_parameters
