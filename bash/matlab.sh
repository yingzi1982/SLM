#!/bin/bash
matlab_script=$1

cd ../octave

matlab -nodisplay -nosplash -nodesktop -r "run('$matlab_script');exit;"

