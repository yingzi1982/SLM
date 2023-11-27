#!/bin/bash

cd ../gmt/

if true; then
  ./plot1DSignal.sh soundPressureEnvelope 2.4i 0.8i thinnest,black lightgray "0 60" 20 "Time (s)" "-1 1" 1 "Signal (Pa)"
fi
