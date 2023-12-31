function [spectrum]=trace2spectrum(signal)
pkg load signal

t = signal(:,1);
s = signal(:,2:end);

dt = t(2)- t(1);
Fs=1/dt;

nfft = 2^nextpow2(length(t));
f = transpose(Fs*(0:(nfft/2))/nfft);
spectrum = fft(s,nfft);
spectrum = 2*abs(spectrum(1:nfft/2+1)/nfft);

spectrum =[f,spectrum];

pkg unload signal
endfunction
