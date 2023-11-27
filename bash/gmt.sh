#!/bin/bash

cd ../gmt/

if true; then
  ./plot1DSignal.sh soundPressureEnvelope "0 10" 2 "Time (s)" "-4 4" 2 "Signal (Pa)"
fi
