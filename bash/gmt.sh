#!/bin/bash

cd ../gmt/

if true; then
  ./plot1DSignal.sh soundPressureEnvelope 2.2i 0.8i thinnest,black lightgray "0 60" 20 "Time (s)" "-1 1" 1 "Signal (Pa)"
fi
if true; then
  ./plot1DSignal.sh soundPressureLevel 2.2i 0.8i thinnest,black lightgray "20 20000" 2000 "Freq (Hz)" "-200 60" 20 "SPL (PaHz)"
fi
