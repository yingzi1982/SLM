#!/usr/bin/env octave
%pkg load signal

clear all
close all
clc

arg_list = argv ();
if length(arg_list) > 0
  wavFolder  = [arg_list{1} '/'];
else
  [arg_list] = input('Please input wavFolder','s');
end

wavList = dir([wavFolder '*wav']);
wavFile = [wavFolder wavList.name];

[~, fullScaledB] = system(['echo ' "'" wavFile "'"' ' | ' "grep -o -P \'(?<=FS).*(?=dB)\'"]);
fullScaledB = str2num(fullScaledB);
soundPressureRef = 20E-6;
fullScalePa = 10^(fullScaledB/20)*soundPressureRef;

audioInfo = audioinfo(wavFile);
fprintf('-----------------------\n')
fprintf('Informaion about the Wav file:\n')
fprintf('FileName      = %s\n', wavFile)
fprintf('SampleRate    = %.1f Hz\n', audioInfo.SampleRate)
fprintf('Duration      = %.1f Sec\n', audioInfo.Duration)
fprintf('BitsPerSample = %d Bit\n', audioInfo.BitsPerSample)
fprintf('FullScale     = %.1f dB\n', fullScaledB)
fprintf('-----------------------\n')

totalSamples = audioInfo.TotalSamples;
[s, fs] = audioread(wavFile);
s = s* fullScalePa;

dt = 1/fs;
t = [0:dt:(totalSamples-1)*dt]';
s = [t s];

np = 2000;
e = trace2envelope(s,np);
dlmwrite('../backup/soundPressureEnvelope',e,' ');

%tClip = [0 0.1];
%[tClip tClipIndex]=findNearest(t,tClip);
%sClip = s([tClipIndex(1):tClipIndex(2)],:);
%whos sClip

%pkg unload signal
