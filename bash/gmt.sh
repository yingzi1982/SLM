#!/bin/bash

cd ../gmt/

if true; then
  ./plot1DSignal.sh soundPressureEnvelope "0 60" 10 "Time (s)" "-1 1" 2 "Signal (Pa)"
fi
