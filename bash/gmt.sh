#!/bin/bash

cd ../gmt/

if true; then
  ./plotSignal.sh soundPressureEnvelope 2.2i 0.8i -W.5p,black -Gorange "0 60" 20 "Time (s)" "-1 1" 1 "Signal (Pa)"
fi

if false; then
  ./plotSignal.sh soundPressureLevel 2.2i 0.8i -W.5p,black " " "900 1100" 50 "Freq (Hz)" "-100 60" 20 "PSD (Pa/Hz)"
fi

if true; then
  ./plotBar.sh LA 2.8i 1.6i "-0.5 36.5" 1 "Freq (Hz)" "0 60" 10 "L@-A@- (dB)"
fi
