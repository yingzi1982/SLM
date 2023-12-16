#!/bin/bash

cd ../gmt/

if false; then
  ./plotSignal.sh soundPressureEnvelope 2.2i 0.8i -Wthinnest,black -Glightgray "0 60" 20 "Time (s)" "-1 1" 1 "Signal (Pa)"
fi

if false; then
  ./plotSignal.sh soundPressureLevel 2.2i 0.8i -Wthinnest,black " " "900 1100" 50 "Freq (Hz)" "-100 60" 20 "PSD (Pa/Hz)"
fi

if true; then
  ./plotBar.sh LA 2.2i 0.8i "-0.5 36.5" 1 "Freq (Hz)" "0 80" 5 "L@-A@- (dB)"
fi
