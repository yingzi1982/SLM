#!/usr/bin/env octave

clear all
close all
clc

pkg load signal

arg_list = argv ();
if length(arg_list) > 0
  wavFolder = arg_list{1};
  timeStepResample = arg_list{2};
  freqStepResample = arg_list{3};

  timeStepResample = str2num(timeStepResample);
  freqStepResample = str2num(freqStepResample);
else
  [arg_list] = input('Please input parameters','s');
end

[~, receiver] = system(['../bash/read_receiver_label.sh ' wavFolder]);
receiver_label = [ strtrim(receiver) ];

wavFileList=dir([wavFolder '*wav']);
for i = 1:length(wavFileList)

wavFile=[wavFolder wavFileList(i).name];

[~, numbering] = system([ "echo \"", wavFile, "\" | tail -c 7 | head -c 2"]);

[~, fullScaledB] = system(['echo ' "'" wavFile "'"' ' | ' "grep -o -P \'(?<=FS).*(?=dB)\'"]);
fullScaledB = str2num(fullScaledB);
soundPressureRef = 20E-6;
fullScalePa = 10^(fullScaledB/20)*soundPressureRef;

audioInfo = audioinfo(wavFile);
fprintf('-----------------------\n')
fprintf('Informaion about the Wav file:\n')
fprintf('WAV File      = %s\n', wavFile)
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

if(1)
  e = trace2envelope(s);
  timeResampleRate = round(timeStepResample/dt);
  e = e(1:timeResampleRate:end,:);
  soundPressureEnvelope_file =[wavFolder 'soundPressureEnvelope' '_' numbering];

  fileID = fopen(soundPressureEnvelope_file,'w');
  fprintf(fileID, '%s\n',receiver_label)
  fclose(fileID);

  dlmwrite(soundPressureEnvelope_file,e,' ', '-append');
  
  fprintf('Max time signal amplitude = %.1e Pa\n', max(abs(e(:,2:end))))
  fprintf('-----------------------\n')

end

if(1)
  S = trace2spectrum(s);
  f = S(:,1);
  df = f(2) - f(1);
  freqResampleRate = round(freqStepResample/df);
  S = S(1:freqResampleRate:end,:);

  soundPressureSpectrum_file =[wavFolder 'soundPressureSpectrum' '_' numbering];
  fileID = fopen(soundPressureSpectrum_file,'w');
  fprintf(fileID, '%s\n',receiver_label)
  fclose(fileID);

  dlmwrite( soundPressureSpectrum_file,S,' ', '-append');
  fprintf('Max spectrum amplitude = %.1e Pa/Hz\n', max(abs(S(:,2:end))))
  fprintf('-----------------------\n')
  S_dB = S;
  Leq=10*log10(sum(S_dB(:,2:end).^2/2)/soundPressureRef^2)
  %S_dB(:,2:end) = 20*log10(S_dB(:,2:end)/sqrt(2)/soundPressureRef);
  %dlmwrite( [wavFolder 'soundPressureSpectrum_dB' '_' numbering '_' receiver_label],S_dB,' ');
  %fprintf('Max spectrum amplitude = %.1e dB/Hz\n', max(abs(S_dB(:,2:end))))
  %fprintf('-----------------------\n')
end

end

pkg unload signal
