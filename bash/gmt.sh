#!/bin/bash

cd ../gmt/

if true; then
  ./plot1DSignal.sh soundPressureEnvelope 2.2i 0.8i -Wthinnest,black -Glightgray "0 60" 20 "Time (s)" "-1 1" 1 "Signal (Pa)"
fi
if true; then
  ./plot1DSignal.sh soundPressureLevel 2.2i 0.8i -Wthinnest,black " " "20 2000" 500 "Freq (Hz)" "-60 60" 20 "SPL (Pa/Hz)"
fi
