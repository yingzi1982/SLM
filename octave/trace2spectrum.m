function [psd]=trace2spectrum(signal)
pkg load signal

t = signal(:,1);
s = signal(:,2:end);

dt = t(2)- t(1);
fs=1/dt;

nfft = 2^nextpow2(length(t));
window= rectwin(nfft);

%f = transpose(Fs*(0:(nfft/2))/nfft);
[pxx,f]= pwelch(s,window,0,nfft,fs);    % W/Hz power spectral density
psd = [f pxx];

pkg unload signal
endfunction
