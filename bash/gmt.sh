#!/bin/bash

cd ../gmt/

if true; then
  ./plot1DSignal.sh soundPressureEnvelope 2.2i 0.8i -Wthinnest,black -Glightgray "0 60" 20 "Time (s)" "-1 1" 1 "Signal (Pa)"
fi
if true; then
  ./plot1DSignal.sh soundPressureLevel 2.2i 0.8i -Wthinnest,black " " "900 1100" 50 "Freq (Hz)" "-60 60" 20 "PSD (Pa/Hz)"
fi
