#!/bin/bash

cd ../gmt/

if true; then
  ./plot1DSignal.sh soundPressureEnvelope "0 60" 20 "Time (s)" "-1 1" 1 "Signal (Pa)"
fi
